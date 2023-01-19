class NavToggle extends HTMLElement {
  connectedCallback() {
    this.addEventListener("click", () => {
      document.querySelector(".nav").classList.toggle("open")
      document.querySelector(".header").classList.toggle("open")
    });
  }
}

customElements.define('nav-toggle', NavToggle);
