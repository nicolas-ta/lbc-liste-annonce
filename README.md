# lbc-liste-annonce

## Environnement
- iOS 12+
- Orientation: Paysage & Portrait
- Archi MVVM

## Features
- Annonces: CollectionView scrollable verticalement affichant les annonces du plus récent au plus ancien
- Affichage des annonces "urgentes" en priorité
- Pour chaque annonce, affichage des la photo, titre, le nom de sa catégorie et prix
- Catégories: CollectionView scrollable horizontalement affichant les différentes catégories disponibles récupérées par l'API
- Affiche pendant quelques secondes l'indicateur de scroll, pour indiquer à l'utilisateur qu'on peut scroller horizontalement la barre des catégories
- Liste des annonces filtrable en cliquant sur une catégorie, qui fait également remonter la liste au début
- Page de détail de chaque annonce en cliquant sur l'annonce correspondante pour afficher: Photo, Titre, Prix, Description, Siret, Date de publication
- Photo dans la page de détail cliquable pour l'afficher en plein écran pour pouvoir zoomer
- Chargement des images de manière asynchrone pour ne pas bloquer la main thread



# Screenshots
<img width="554" alt="Capture d’écran 2021-05-05 à 11 19 28" src="https://user-images.githubusercontent.com/11645292/117120561-c31a2380-ad93-11eb-91fc-de3f96cf4fb1.png"><img width="554" alt="Capture d’écran 2021-05-05 à 11 21 10" src="https://user-images.githubusercontent.com/11645292/117120731-007eb100-ad94-11eb-8c45-71f4534de323.png">
<img width="964" alt="Capture d’écran 2021-05-05 à 11 19 39" src="https://user-images.githubusercontent.com/11645292/117120578-c9a89b00-ad93-11eb-8d1d-ca6aa72a9ce7.png">
<img width="970" alt="Capture d’écran 2021-05-05 à 11 20 36" src="https://user-images.githubusercontent.com/11645292/117120675-eba21d80-ad93-11eb-9a0f-4cc85c66e90c.png">
<img width="738" alt="Capture d’écran 2021-05-05 à 11 21 59" src="https://user-images.githubusercontent.com/11645292/117120835-1ee4ac80-ad94-11eb-8117-bbd02335d1d4.png">
