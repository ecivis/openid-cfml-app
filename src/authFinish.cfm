<cfsilent>
	<cfif application.openIDConsumer.authVerify()>
		<cflocation url="/index.cfm?status=success" addtoken="false"/>
	<cfelse>
		<cflocation url="/index.cfm?status=failure" addtoken="false"/>
	</cfif>
</cfsilent>