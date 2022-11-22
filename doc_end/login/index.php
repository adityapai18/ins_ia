<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://unpkg.com/flowbite@1.5.4/dist/flowbite.min.css" />
    <script src="https://unpkg.com/flowbite@1.5.4/dist/flowbite.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js" integrity="sha512-E8QSvWZ0eCLGk4km3hxSsNmGWbLtSCSUcewDQPQWZF6pEU8GlT8a5fF32wOl1i8ftdMhssTrF/OhyGWwonTcXA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/aes.min.js" integrity="sha512-4b1zfeOuJCy8B/suCMGNcEkMcQkQ+/jQ6HlJIaYVGvg2ZydPvdp7GY0CuRVbNpSxNVFqwTAmls2ftKSkDI9vtA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/hmac-sha256.min.js" integrity="sha512-HMqYytekgCbPoNWBm9oazvuOJ8sFpw+FWBHRi2QM0f/bV5djDV1sRzWzu5Jq7MAUlm+zDAUCgi/vHBBlUGLroQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/hmac-sha256.min.js" integrity="sha512-HMqYytekgCbPoNWBm9oazvuOJ8sFpw+FWBHRi2QM0f/bV5djDV1sRzWzu5Jq7MAUlm+zDAUCgi/vHBBlUGLroQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<?php
session_start();
?>

<body class="h-screen flex items-center justify-center">
    <div class="w-full max-w-sm p-4 bg-white border border-gray-200 rounded-lg shadow-md sm:p-6 md:p-8  ">
        <form class="space-y-6" action="../../api/doctor/auth/login.php" method="POST">
            <h5 class="text-xl font-medium text-gray-900">Sign in to MyDoctor</h5>
            <div>
                <label for="email" class="block mb-2 text-sm font-medium text-gray-900 ">Your email</label>
                <input type="email" name="email" id="email" class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5 " placeholder="name@company.com" required="">
            </div>
            <div>
                <label for="password" class="block mb-2 text-sm font-medium text-gray-900 ">Password</label>
                <input type="passwd" oninput="passwordChange(this.value)" name="passwd" id="passwd" placeholder="••••••••" class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-blue-600 focus:border-blue-600 block w-full p-2.5" required="">
                <input type="hidden" id="pass" name="pass" value="">
            </div>
            <div class="flex items-center justify-between">
                <div class="flex items-start">
                    <div class="flex items-center h-5">
                        <input id="remember" aria-describedby="remember" type="checkbox" class="w-4 h-4 border border-gray-300 rounded bg-gray-50 focus:ring-3 focus:ring-blue-300 " required="">
                    </div>
                    <div class="ml-3 text-sm">
                        <label for="remember" class="text-gray-500 ">Remember me</label>
                    </div>
                </div>
                <a href="#" class="text-sm font-medium text-blue-600 hover:underline ">Forgot password?</a>
            </div>
            <button type="submit" class="w-full text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center ">Sign in</button>
            <p class="text-sm font-light text-gray-500 ">
                Don’t have an account yet? <a href="#" class="font-medium text-blue-600 hover:underline ">Sign up</a>
            </p>
        </form>
    </div>
    <script>
        function passwordChange(pass) {
            var message = sha_256(pass);
            var key = '6B5970337336763979244226452948404D6351655468576D5A7134743777217A';
            var key = CryptoJS.enc.Hex.parse("6B5970337336763979244226452948404D6351655468576D5A7134743777217A");
            var iv = CryptoJS.lib.WordArray.random(16);
            var encrypted = CryptoJS.AES.encrypt(message, key, {
                iv: iv
            });
            var hash = CryptoJS.HmacSHA256(encrypted.iv + encrypted.ciphertext, key);
            document.getElementById('pass').value = encrypted.iv + getHMAC(encrypted.iv, encrypted.ciphertext, key) + encrypted.ciphertext;
        }

        function getHMAC(iv, ciphertext, key) {
            return CryptoJS.HmacSHA256(iv + ciphertext, key)
        }

        function sha_256(message) {
            return CryptoJS.SHA256(message);
        }
    </script>
</body>

</html>