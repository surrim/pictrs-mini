# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.bundle.min.js"
pin "js-cookie", to: "https://cdn.jsdelivr.net/npm/js-cookie@3.0.5/dist/js.cookie.min.js"
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.js"
