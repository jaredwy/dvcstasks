

<html>
<head>
	<title>Help</title>
    <meta name="decorator" content="helppage">
</head>

<body>
	<h1>CVS Locking</h1>

    <p> This means you're trying to access a subdirectory that's locked by some other CVS process at the moment</p>

    <p>A process is being run in that directory so it may not be in a consistent state for other CVS processes to use. If the wait message persists for a long time,
    it probably means that a CVS process failed to clean up after itself. This can happen when CVS dies suddenly and unexpectedly.</p>

    <p>The solution is to remove the lock files by hand. Go into that part of the repository and look for files named <b>[@cvs /].lock</b> or that begin with <b>[@cvs /].wfl</b>
    or <b>[@cvs /].rfl</b>. The waiting CVS processes eventually notice that the lock files are gone and allow the requested operation to proceed.</p>
</body>
</html>