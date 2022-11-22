<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://unpkg.com/flowbite@1.5.4/dist/flowbite.min.css" />
</head>

<body>
    <!-- component -->
    <style>
        @import url(https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/5.3.45/css/materialdesignicons.min.css);
    </style>
    <div class="min-w-screen min-h-screen bg-blue-700 flex items-center p-5 lg:p-20 overflow-hidden relative">
        <div class="flex-1 min-h-full min-w-full rounded-3xl dark:bg-gray-900 shadow-xl p-10 lg:p-20 text-gray-800 relative md:flex items-center text-center md:text-left">
            <div class="w-full md:w-1/2">

                <div class="mb-10 md:mb-20 text-gray-600 font-light">
                    <h1 class="font-black uppercase text-3xl lg:text-5xl text-yellow-500 mb-10">You seem to be lost!</h1>
                    <p>The page you're looking for isn't available.</p>
                    <p>Try searching again or use the Go Back button below.</p>
                </div>
                <div class="mb-20 md:mb-0">
                    <button onclick="window.history.back()" class="text-lg font-light outline-none focus:outline-none transform transition-all hover:scale-110 text-yellow-500 hover:text-yellow-600"><i class="mdi mdi-arrow-left mr-2"></i>Go Back</button>
                </div>
            </div>
            <div class="w-full md:w-1/2 text-center">
                <script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
                <lottie-player src="https://assets3.lottiefiles.com/packages/lf20_bhw1ul4g.json" background="transparent" speed="1" loop autoplay></lottie-player>
            </div>
        </div>
</body>

</html>