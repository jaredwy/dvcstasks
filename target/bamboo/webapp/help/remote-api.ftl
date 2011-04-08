<html>
<head>
	<title>[@ww.text name='bamboo.help.title'/]</title>
	<meta name="decorator" content="helppage">
</head>

<body>
	<h1>[@ww.text name='bamboo.help.remoteApi.title'/]</h1>

    <p>[@ww.text name='bamboo.help.remoteApi.description'/]</p>

    <h2>[@ww.text name='bamboo.help.remoteApi.enable.title'/]</h2>
    <p>
        [@ww.text name='bamboo.help.remoteApi.enable.disabled'/]
    </p>

    <p>
        [@ww.text name='bamboo.help.remoteApi.enable.toEnable']
            [@ww.param]${req.contextPath}[/@ww.param]
        [/@ww.text]
    </p>
    <p><img src="../images/accept_remote_calls.jpg" border="0"></p>

    <p>[@ww.text name='bamboo.help.remoteApi.enable.enabled'/]</p>

    <h2>[@ww.text name='bamboo.help.remoteApi.calling.title'/]</h2>

    <p>
        [@ww.text name='bamboo.help.remoteApi.calling.description']
            [@ww.param]${req.contextPath}[/@ww.param]
        [/@ww.text]
    </p>
</body>
</html>