import "@hotwired/turbo-rails"
import React from "react";
import ReactDOM from "react-dom/client";
import Dashboard from "./components/Dashboard";
import "./controllers"

function mountComponent(id, Component) {
    const container = document.getElementById(id);
    if (container) {
        const root = ReactDOM.createRoot(container);
        root.render(<Component />);
    }
}

document.addEventListener("turbo:load", () => {
    mountComponent("react-dashboard", Dashboard);
});

