document.addEventListener('DOMContentLoaded', (event) => {
    const profilePicture = document.getElementById('profile-picture');
    
    // Replace 'path/to/your/image.jpg' with the actual path to your image
    // If you're using Azure Blob Storage, you'll need to use the full URL to your image
    profilePicture.style.backgroundImage = "url('path/to/your/image.jpg')";
    
    // If you prefer to use a background image for the whole page instead,
    // uncomment the following line and replace with your image path:
    // document.body.style.backgroundImage = "url('path/to/your/background-image.jpg')";
});