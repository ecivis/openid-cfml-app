<cfsilent>
	<cfset identifier = structKeyExists(form, "identifier") ? form.identifier : ""/>

	<cfif len(identifier)>
		<cfset result = application.openIDConsumer.authRequest(identifier)/>
	</cfif>
</cfsilent><cfcontent reset="true" type="application/json"/><cfoutput>#serializeJSON(result)#</cfoutput>