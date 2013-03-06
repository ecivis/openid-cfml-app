<cfsilent>
	<cfset isLoggedIn = false/>
	<cfif structKeyExists(session, "isLoggedIn") and session.isLoggedIn>
		<cfset isLoggedIn = true/>
	</cfif>
</cfsilent>
<!DOCTYPE html>
<html>
<head>
	<title>OpenID Example Home</title>
	
	<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet"/>
</head>
<body>
	<div class="container">
		<h2>OpenID Example</h2>
		
		<cfif not isLoggedIn>
			<form id="authRequest" class="form-horizontal">
				<div class="control-group">
					<label for="identifier" class="control-label">Identifier</label>
					<div class="controls">
						<input type="text" id="identifier" value=""/>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<button class="btn">Authenticate</button>
					</div>
				</div>
			</form>
			<form id="authProceed" method="POST" action="">
				<input type="hidden" class="template" name="" value=""/>
			</form>
		<cfelse>
			<cfoutput>
				<cfif structKeyExists(session, "email")>
					<p>Hello #session.email#.</p>
				<cfelse>
					<p>Hello Valid User</p>
				</cfif>
			</cfoutput>
		</cfif>
    </div>
	
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<script src="/assets/js/app.js"></script>
</body>
</html>
