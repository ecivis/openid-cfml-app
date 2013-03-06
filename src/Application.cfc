<cfcomponent output="false">

	<cfset this.name = "openid4cf"/>
	<cfset this.applicationTimeout = createTimespan(2, 0, 0, 0)/>
	<cfset this.sessionManagement = true/>
	<cfset this.sessionTimeout = createTimespan(0, 0, 30, 0)/>
	<cfset this.setClientCookies = false/>

	<cfset variables.config = structNew()/>
	<cfset variables.config.proxyHost = "localhost"/>
	<cfset variables.config.proxyPort = 8888/>
	<cfset variables.config.returnUrl = "http://localhost:8080/authFinish.cfm"/>

	<cffunction name="onApplicationStart" returntype="boolean" access="public" output="false">
		<cflock name="applicationStartLock" type="exclusive" timeout="5">
			<cfset application.openIDConsumer = createObject("component", "model.openid.Consumer").init(variables.config)/>
			<cfset application.initialized = now()/>
		</cflock>
		<cfreturn true/>
	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean" access="public" output="false">
		<cfif structKeyExists(url, "reinit")>
			<cfset onApplicationStart()/>
		</cfif>
		<cfreturn true/>
	</cffunction>

</cfcomponent>