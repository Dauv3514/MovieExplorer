# Name

Dauvier Valentin

# Movie Explorer

Application Flutter permettant de rechercher des films via l'API OMDb, de consulter leurs details et de gerer une liste de favoris en local.

## Apercu

Movie Explorer propose une experience simple autour de la decouverte de films :

- recherche de films par titre
- affichage d'une selection initiale de films au lancement
- consultation d'une fiche detaillee pour chaque film
- ajout et suppression de favoris
- sauvegarde locale des favoris avec `SharedPreferences`
- bascule entre theme clair et theme sombre

## Technologies utilisees

- Flutter
- Dart
- Provider
- HTTP
- `flutter_dotenv`
- `shared_preferences`
- API [OMDb](https://www.omdbapi.com/)

## Installation

### 1. Recuperer les dependances

```bash
flutter pub get
```

### 2. Configurer la cle API

Creer un fichier `.env` a la racine du projet `movie_explorer` avec la variable suivante :

```env
OMDB_API_KEY=ta_cle_api
```

Tu peux recuperer une cle sur le site officiel : [https://www.omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx)

### 3. Lancer l'application

```bash
flutter run
```

## Structure du projet

```text
lib/
|- models/       # modeles de donnees film et details
|- providers/    # gestion du theme et des favoris
|- services/     # appels a l'API OMDb
|- ui/           # ecrans principaux et widgets
|- main.dart     # point d'entree de l'application
```

## Fonctionnalites principales

### Recherche de films

L'utilisateur peut rechercher un film par son titre. La recherche utilise un delai court pour eviter les appels API inutiles pendant la saisie.

### Page de details

Chaque film dispose d'une page detail avec :

- l'affiche
- le titre
- l'annee
- le resume
- les acteurs
- la note IMDb

### Favoris

Les films peuvent etre ajoutes ou retires des favoris. La liste est conservee localement pour etre retrouvee au prochain lancement.

### Theme

L'application integre un bouton pour passer du theme clair au theme sombre.

## Points d'attention

- sans cle API valide dans `.env`, l'application affiche un message d'erreur
- les favoris sont stockes localement sur l'appareil
- le theme n'est pas persiste actuellement entre les sessions

## Commandes utiles

```bash
flutter analyze
flutter test
```

## Auteur

Projet realise par Dauvier Valentin.