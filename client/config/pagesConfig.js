var pagesConfig = {
    error: {
        title: "Error",
        noLoginCheck: true
    },
    login:{
        title: "Login",
        pageName: "Login",
        noLoginCheck: true
    },
    home:{
        title: "Home",
        pageName: "Accueil"
    },
    options:{
        title: "Options",
        pageName: "Options",
        hideOptionsBtn: true,
        noLoginCheck: true
    },
    new_game:{
        title: "Choix de la partie",
        pageName: "Choix de la partie",
        view: "newgame"
    },
    lobby_host:{
        title: "Création de la partie",
        pageName: "Création de la partie",
        view: "lobby"
    },
    lobby:{
        title: "Création de la partie",
        pageName: "Création de la partie",
        view: "lobby"
    },
    new_level:{
        title: "Create level",
        pageName: "Création de niveau",
        view: "new_level",
        data: [
            {
                source: "music",
                container: "#musicSelector",
                adapter: "insertMusicList"
            }
        ]
    },
    level_editor:{
        title: "Création de rythme",
        pageName: "Création de rythm",
        view: "level_editor"
    },
    levels:{
        title: "Replay",
        data: [
            {
                source: "levels",
                container: "#levelsContainer",
                adapter: "levelAdapter"
            }
        ],
        pageName: "Replay",
        view: "replay_level"
    },
    replays:{
        title: "Replay",
        view: "replay"
    },
    replay_player:{
        title: "Replay (player)" //as in video player :)
    },
    game:{
        title: "Partie en cours",
        pageName: "Partie en cours",
        view: "game"
    },
    demo:{
        title: "Demonstration",
        pageName: "demo"
    }
};