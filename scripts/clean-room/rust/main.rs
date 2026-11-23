//! A program built on the crates as crates.io serves them.

fn main() {
    println!("{}", std::any::type_name::<xynolog::client::XynologClient>());
    println!("{}", std::any::type_name::<xynolog_http_transport::transport::HttpTransport>());
}
