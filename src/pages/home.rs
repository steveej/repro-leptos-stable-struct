use leptos::prelude::*;

/// Default Home Page
#[component]
pub fn Home() -> impl IntoView {
    view! {
        // this is the meta-title, not visible on the page itself
        <title>"repro"</title>
    }
}
