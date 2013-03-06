<cfcomponent output="false">

	<cffunction name="init" returntype="Consumer" access="public" output="false">
		<cfargument name="config" type="struct" required="true"/>

		<cfset var proxyProps = "null"/>
		
		<cfset variables.config = arguments.config/>

		<cfset proxyProps = createObject("java", "org.openid4java.util.ProxyProperties").init()/>
		<cfset proxyProps.setProxyHostName(variables.config.proxyHost)/>
		<cfset proxyProps.setProxyPort(variables.config.proxyPort)/>
		<cfset createObject("java", "org.openid4java.util.HttpClientFactory").setProxyProperties(proxyProps)/>
		<cfset variables.manager = createObject("java", "org.openid4java.consumer.ConsumerManager")/>
		<cfset variables.axMessage = createObject("java", "org.openid4java.message.ax.AxMessage")/>
		<cfreturn this/>
	</cffunction>

	<cffunction name="authRequest" returntype="struct" access="public" output="false">
		<cfargument name="identifier" type="string" required="true"/>

		<cfset var discoveries = "null"/>
		<cfset var discovered = "null"/>
		<cfset var authRequest = "null"/>
		<cfset var fetch = "null"/>
		<cfset var result = structNew()/>
		
		<cfset discoveries = variables.manager.discover(arguments.identifier)/>
		<cfset discovered = variables.manager.associate(discoveries)/>
		<cfset authRequest = variables.manager.authenticate(discovered, variables.config.returnUrl)/>
		<cfset fetch = createObject("java", "org.openid4java.message.ax.FetchRequest").createFetchRequest()/>

		<cfset fetch.addAttribute("email", "http://schema.openid.net/contact/email", false)/>
		<cfset authRequest.addExtension(fetch)/>

		<cfif not discovered.isVersion2()>
			<cfset result["method"] = "GET"/>
			<cfset result["parameters"] = structNew()/>
			<cfset result["destinationUrl"] = authRequest.getDestinationUrl(true)/>
		<cfelse>
			<cfset result["method"] = "POST"/>
			<cfset result["parameters"] = authRequest.getParameterMap()/>
			<cfset result["destinationUrl"] = authRequest.getDestinationUrl(false)/>
		</cfif>
		
		<cfset session.openIDRef = discovered/>
		
		<cfreturn result/>
	</cffunction>

	<cffunction name="authVerify" returntype="boolean" access="public" output="false">
		<cfset var returnUrl = variables.config.returnUrl/>
		<cfset var verification = "null"/>
		<cfset var verified = "null"/>
		<cfset var authSuccess = "null"/>
		<cfset var parameterList = createObject("java", "org.openid4java.message.ParameterList").init()/>
		<cfset var key = ""/>
		<cfset var value = ""/>
		<cfset var fetchResp = "null"/>
		<cfset var emails = "null"/>
		<cfset var email = "undefined"/>

		<cfif not structKeyExists(session, "openIDRef")>
			<cfthrow message="Invalid OpenID data in session."/>
		</cfif>
		
		<cfif structKeyExists(cgi, "QUERY_STRING")>
			<cfset returnUrl = returnUrl & "?" & cgi["QUERY_STRING"]/>
		</cfif>
		
		<cfloop collection="#url#" item="key">
			<cfset value = url[key]/>
			<cfif not isSimpleValue(key) or not isSimpleValue(value)>
				<cfcontinue/>
			</cfif>
			<cfset parameterList.set(createObject("java", "org.openid4java.message.Parameter").init(key, value))/>
		</cfloop>
		<cfloop collection="#form#" item="key">
			<cfset value = form[key]/>
			<cfif not isSimpleValue(key) or not isSimpleValue(value)>
				<cfcontinue/>
			</cfif>
			<cfset parameterList.set(createObject("java", "org.openid4java.message.Parameter").init(key, value))/>
		</cfloop>
		
		<cfset verification = manager.verify(returnUrl, parameterList, session.openIDRef)/>
		<cfif isNull(verification.getVerifiedId())>
			<cfreturn false/>
		</cfif>
		<cfset session.isLoggedIn = true/>

		<cfset authSuccess = verification.getAuthResponse()/>
		<cfif authSuccess.hasExtension(variables.axMessage.OPENID_NS_AX)>
			<cfset fetchResp = authSuccess.getExtension(variables.axMessage.OPENID_NS_AX)/>
			<cfset emails = fetchResp.getAttributeValues("email")/>
			<cfif emails.size() gt 0>
				<cfset session.email = emails.get(0)/>
			</cfif>
		</cfif>
		<cfreturn true/>
	</cffunction>

</cfcomponent>