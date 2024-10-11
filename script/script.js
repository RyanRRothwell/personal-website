const greetingElement = document.getElementById('greeting');
const aboutMeElement = document.getElementById('about-me');
let isSpanish = false;

function setLanguage() {
    const language = navigator.language || navigator.userLanguage;
    isSpanish = language.startsWith('es');
}

function updateGreeting(message) {
    greetingElement.textContent = message;
}

function showAboutMe() {
    greetingElement.style.display = 'none';
    aboutMeElement.style.display = 'block';
    document.body.classList.add('static-page');
}

function animateGreetings() {
    const greetings = isSpanish
        ? [
            "Hola Mundo",
            "Bienvenidos a mi página web",
            "¿Cómo puedo ayudarte hoy?",
            "Espero que disfrutes tu visita"
        ]
        : [
            "Hello World",
            "Welcome to my website",
            "How can I help you today?",
            "I hope you enjoy your visit"
        ];

    greetings.forEach((greeting, index) => {
        setTimeout(() => {
            updateGreeting(greeting);
        }, index * 3000); // Change every 3 seconds
    });

    // Show about me section after all greetings have been shown
    setTimeout(showAboutMe, greetings.length * 3000);
}

setLanguage();
animateGreetings();