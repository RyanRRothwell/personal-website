// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Navbar color change on scroll
window.addEventListener('scroll', function() {
    if (window.scrollY > 50) {
        document.querySelector('.navbar').style.backgroundColor = 'rgba(255, 255, 255, 0.9)';
    } else {
        document.querySelector('.navbar').style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
    }
});

// Active state for navbar items
window.addEventListener('scroll', function() {
    let scrollPosition = window.scrollY;

    document.querySelectorAll('section').forEach(section => {
        if (scrollPosition >= section.offsetTop - 100 && scrollPosition < (section.offsetTop + section.offsetHeight - 100)) {
            let currentId = section.attributes.id.value;
            removeAllActiveClasses();
            addActiveClass(currentId);
        }
    });
});

function removeAllActiveClasses() {
    document.querySelectorAll(".nav-link").forEach((el) => {
        el.classList.remove("active");
    });
}

function addActiveClass(id) {
    let selector = `.navbar-nav .nav-link[href="#${id}"]`;
    document.querySelector(selector).classList.add("active");
}

// Form submission (you'll need to implement the actual form submission logic)
document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();
    // Add your form submission logic here
    alert('Form submitted! (This is a placeholder - implement your actual form submission logic)');
});