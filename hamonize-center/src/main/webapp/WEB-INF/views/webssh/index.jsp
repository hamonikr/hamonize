<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title> WebSSH </title>
    <link href="/img/favicon.png" rel="icon" type="image/png"/>
    <link rel="stylesheet" type="text/css" href="/css/webssh/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/css/webssh/xterm.min.css" />
    <!-- <link rel="stylesheet" type="text/css" href="/css/webssh/fullscreen.min.css" /> -->

    <style>
        .row {
            margin-top: 20px;
            margin-bottom: 10px;
        }

        .container {
            margin-top: 20px;
        }

    </style>
</head>
<body>
<div class="container">
    <form id="connect" action="/ssh" type="post" enctype="multipart/form-data">
        <div class="row">
            <div class="col">
                <label for="Hostname">Hostname</label>
                <input class="form-control" type="text" name="hostname" value="${hostname}"/>
            </div>
            <div class="col">
                <label for="Port">Port</label>
                <input class="form-control" type="text" name="port" value="22"/>
            </div>
        </div>
        <div class="row">
            <div class="col">
                <label for="Username">Username</label>
                <input class="form-control" type="text" name="username" value="hamonize"/>
            </div>
            <!-- <div class="col">
                <label for="Username">Private Key</label>
                <input class="form-control" type="file" name="privatekey" value=""/>
            </div> -->
        </div>
        <div class="row">
            <div class="col">
                <label for="Password">Password</label>
                <input class="form-control" type="password" name="password" placeholder="" value=""/>
            </div>
            <!-- <div class="col">
                If Private Key is chosen, password will be used to decrypt the Private Key if it is encrypted, otherwise
                used as the password of username.
            </div> -->
        </div>
        <button type="submit" class="btn btn-primary">Connect</button>
    </form>

</div>

<div class="container">
    <div id="status" style="color: red;"></div>
    <div id="terminal"></div>
</div>

<script type="text/javascript" src="/js/webssh/jquery.min.js"></script>
<script type="text/javascript" src="/js/webssh/popper.min.js"></script>
<script type="text/javascript" src="/js/webssh/bootstrap.min.js"></script>
<script type="text/javascript" src="/js/webssh/xterm.min.js"></script>
<script type="text/javascript" src="/js/webssh/fullscreen.min.js"></script>
<script type="text/javascript" src="/js/webssh/main.js"></script>
</body>
</html>
