// Modules
mod pages;

// Top-Level pages
use crate::pages::home::Home;
use crate::pages::not_found::NotFound;

use leptos::prelude::*;
use leptos_router::components::*;

/// An app router which renders the homepage and handles 404's
// #[component]
pub fn App() -> impl IntoView {
    view! {
        <Router>
            <Routes fallback=NotFound>
                <Route path=leptos_router::path!("/") view=Home/>
            </Routes>
        </Router>
    }
}
