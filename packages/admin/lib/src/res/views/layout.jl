<!DOCTYPE html>
<declare config=angel_admin_configuration>
    <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.css">
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
            <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
            <style>
                :root {
                    --mdc-theme-primary: #03A9F4;
                }

                html, body {
                    background-color: #f1f1f1;
                    font-family: 'Roboto', sans-serif;
                    margin: 0;
                    padding: 0;
                }

                .mdc-drawer__header {
                    background-color: var(--mdc-theme-primary);
                    color: var(--mdc-theme-on-primary);
                }

                .mdc-top-app-bar--fixed {
                    box-shadow: 0 0 10px grey;
                }
            </style>
            <title>{{ title }} | {{ angel_admin_title }}</title>
            <style for-each=config.styles as="style">
                {{- style }}
            </style>
            <block name="head"></block>
        </head>
        <body>
            <block name="body">
                <block name="app_bar">
                    <header class="mdc-top-app-bar mdc-top-app-bar--fixed">
                      <div class="mdc-top-app-bar__row">
                        <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
                          <a id="menu-button" class="material-icons mdc-top-app-bar__navigation-icon">menu</a>
                          <span class="mdc-top-app-bar__title">{{ title }}</span>
                        </section>
                        <block name="actions"></block>
                      </div>
                    </header>
                </block>
                <main class="mdc-top-app-bar--fixed-adjust">
                    <aside class="mdc-drawer mdc-drawer--temporary mdc-typography">
                      <nav class="mdc-drawer__drawer">

                        <header class="mdc-drawer__header">
                          <div class="mdc-drawer__header-content">
                            {{ angel_admin_username }}
                          </div>
                        </header>

                        <nav id="icon-with-text-demo" class="mdc-drawer__content mdc-list">
                          <a class="mdc-list-item mdc-list-item--activated" href=angel_admin_root>
                            <i class="material-icons mdc-list-item__graphic" aria-hidden="true">dashboard</i>
                            Dashboard
                          </a>
                          <a
                            for-each=config.services.keys
                            as="name"
                            class="mdc-list-item"
                            href=join(name)>
                                <declare service=config.services[name]>
                                  <i if=service.icon != null class="material-icons mdc-list-item__graphic" aria-hidden="true">{{ service.icon }}</i>
                                  {{ service.name }}
                                </declare>
                          </a>
                          <a class="mdc-list-item" href="/">
                            <i class="material-icons mdc-list-item__graphic" aria-hidden="true">exit_to_app</i>
                            Exit Admin Panel
                          </a>
                        </nav>
                      </nav>
                    </aside>
                    <div style="padding: 1em">
                        <block name="content"></block>
                    </div>
                </main>
                <script src="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.js"></script>
                <script>
                    window.addEventListener('load', function() {
                        mdc.autoInit();

                        var drawer = new mdc.drawer.MDCTemporaryDrawer(document.querySelector('.mdc-drawer'));
                        document.querySelector('#menu-button').addEventListener('click', () => drawer.open = !drawer.open);
                    });
                </script>
                <block name="scripts"></block>
            </block>
        </body>
    </html>
</declare>