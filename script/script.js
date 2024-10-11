const greetingElement = document.getElementById('greeting');
let isSpanish = false;

function setLanguage() {
    const language = navigator.language || navigator.userLanguage;
    isSpanish = language.startsWith('es');
}

function updateGreeting(message) {
    greetingElement.textContent = message;
}

function animateGreetings() {
    const greetings = isSpanish
        ? [
            "Hola Mundo",
            "Bienvenidos a ",
            "Mi página web",
            "Espero que disfrutes",
            "Tu visita"
        ]
        : [
            "Hello World",
            "Welcome to",
            "My website",
            "I hope you enjoy",
            "Your visit"
        ];

    greetings.forEach((greeting, index) => {
        setTimeout(() => {
            updateGreeting(greeting);
        }, index * 3000); // Change every 3 seconds
    });

    // Restart the animation after all greetings have been shown
    setTimeout(animateGreetings, greetings.length * 3000);
}

setLanguage();
animateGreetings();