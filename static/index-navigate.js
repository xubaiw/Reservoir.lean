/**
 * This module handles the interaction with the navigation input, 
 * and filters the index page.
 */

document.querySelector(`header > input`).addEventListener("input", handleNavigateInput);

function handleNavigateInput(event) {
    let value = event.target.value;

    document.querySelectorAll(`main > ul > li > a`).forEach(el => {
        if (el.innerHTML.includes(value)) {
            el.parentElement.style.display = "list-item";
        } else {
            el.parentElement.style.display = "none";
        }
    });
}