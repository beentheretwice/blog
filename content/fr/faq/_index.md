---
title: "Questions Fréquentes - WaqtSalat"
description: "Trouvez les réponses aux questions courantes sur les horaires de prière, les méthodes de calcul, l'utilisation hors ligne et les fonctionnalités de confidentialité de WaqtSalat."
date: 2026-03-11
draft: false
layout: "faq"
type: "faq"
keywords: ["FAQ", "questions horaires prière", "méthode habous", "application prière hors ligne", "confidentialité"]
---

# Questions Fréquentes

Trouvez les réponses aux questions courantes sur WaqtSalat, le calcul des horaires de prière et l'utilisation efficace de l'application.

## Calcul des Horaires de Prière

### Quelle méthode de calcul WaqtSalat utilise-t-il ?

WaqtSalat utilise la **méthode du Ministère des Habous**, qui est le calcul officiel des horaires de prière au Maroc :

- **Angle Fajr :** 19° (soleil sous l'horizon)
- **Angle Isha :** 17° (soleil sous l'horizon)
- **Asr :** Méthode Shafi'i

Cela correspond aux horaires annoncés dans les mosquées locales du Maroc.

### Pourquoi différentes applications affichent-elles des horaires différents ?

De nombreuses applications de prière utilisent des méthodes de calcul conçues pour d'autres pays :

| Méthode | Région | Fajr | Isha |
|---------|--------|------|------|
| **Habous** | Maroc | 19° | 17° |
| Umm al-Qura | Arabie Saoudite | 18,5° | Fixe |
| MWL | International | 18° | 17° |
| Égyptienne | Égypte | 19,5° | 17,5° |

WaqtSalat est spécifiquement conçu pour le Maroc et utilise la méthode Habous locale.

### Pourquoi le Maroc affiche-t-il six horaires de prière au lieu de cinq ?

Le Maroc inclut **Chourouk (lever du soleil)** en plus des cinq prières quotidiennes :

1. Fajr - Prière de l'aube
2. **Chourouk - Lever du soleil (pas une prière)**
3. Dhuhr - Prière de midi
4. Asr - Prière de l'après-midi
5. Maghrib - Prière du coucher
6. Isha - Prière de la nuit

Chourouk marque l'heure de fin pour la prière Fajr. Vous ne pouvez pas prier Fajr après Chourouk.

### Quelle est la précision des calculs de WaqtSalat ?

WaqtSalat calcule les horaires à la seconde près basé sur :
- Coordonnées exactes de la ville
- Fuseau horaire du Maroc (GMT+0/GMT+1)
- Angles officiels du Ministère des Habous

Les horaires correspondent à ce que vous entendez des mosquées locales.

---

## Utilisation de l'Application

### WaqtSalat fonctionne-t-il hors ligne ?

**Oui !** WaqtSalat fonctionne complètement hors ligne après la configuration initiale :

1. Téléchargez l'application
2. Sélectionnez votre ville (stockée localement)
3. Les horaires de prière sont calculés sur votre appareil
4. Aucune connexion internet nécessaire pour l'usage quotidien

C'est idéal pour les voyages, les zones avec mauvaise connectivité, ou pour éviter l'utilisation de données.

### Puis-je ajuster les horaires de prière pour correspondre à ma mosquée locale ?

Absolument. WaqtSalat permet des **ajustements de ±15 minutes** pour chaque prière :

- Ouvrez Paramètres
- Sélectionnez la prière à ajuster
- Déplacez le curseur pour correspondre à votre mosquée

Cela prend en compte les variations locales dans le timing de l'Adhan.

### Comment activer les notifications Adhan ?

1. Ouvrez WaqtSalat
2. Allez dans Paramètres → Notifications
3. Activez "Adhan à l'heure de prière"
4. Choisissez votre réciteur préféré

Vous entendrez l'appel à la prière à chaque heure de prière.

### Quelles villes sont supportées ?

WaqtSalat supporte **35+ villes marocaines**, incluant :
- Rabat, Casablanca, Marrakech, Fès, Tanger, Agadir
- Meknès, Oujda, Kénitra, Tétouan, Safi
- El Jadida, Béni Mellal, Nador, et beaucoup plus

Sélectionnez votre ville dans la liste pour des horaires locaux exacts.

---

## Confidentialité & Données

### WaqtSalat collecte-t-il mes données personnelles ?

**Non.** WaqtSalat est conçu avec la confidentialité comme priorité :

- Aucun compte requis
- Aucune information personnelle collectée
- Aucun suivi de localisation (vous sélectionnez votre ville)
- Aucune analyse ou suivi tiers

### WaqtSalat est-il open source ?

**Oui !** WaqtSalat est entièrement open source :

- Code source disponible sur GitHub
- Licence MIT
- Contributions communautaires bienvenues
- Transparent et auditable

Consultez le code sur [github.com/waqtsalat](https://github.com/waqtsalat/waqtsalat)

### WaqtSalat affiche-t-il des publicités ?

**Jamais.** WaqtSalat est entièrement sans publicité :

- Pas de bannières publicitaires
- Pas de publicités vidéo
- Pas de contenu sponsorisé
- Pas de "mise à niveau premium"

Les horaires de prière devraient être gratuits et accessibles à tous.

### WaqtSalat suit-il ma localisation ?

**Non.** WaqtSalat n'utilise pas le GPS ou les services de localisation :

- Vous sélectionnez manuellement votre ville
- Les coordonnées sont stockées localement
- Aucun suivi de localisation en arrière-plan
- Aucune donnée de localisation transmise

---

## Questions Techniques

### Quels appareils supportent WaqtSalat ?

WaqtSalat est une **Progressive Web App (PWA)** qui fonctionne sur :

- **Android :** Support complet avec notifications Adhan
- **iOS :** Support complet (installer via Safari)
- **Bureau :** Chrome, Firefox, Edge, Safari

Installez-le comme une application native depuis votre navigateur.

### Comment installer WaqtSalat sur mon téléphone ?

**Android :**
1. Visitez waqtsalat.github.io/waqtsalat dans Chrome
2. Appuyez sur "Ajouter à l'écran d'accueil"
3. L'icône de l'application apparaît sur votre écran d'accueil

**iOS :**
1. Visitez waqtsalat.github.io/waqtsalat dans Safari
2. Appuyez sur le bouton Partager
3. Sélectionnez "Sur l'écran d'accueil"

### Pourquoi l'heure d'Isha semble-t-elle tardive/précoce ?

L'heure d'Isha varie significativement tout au long de l'année :

- **Été :** Isha peut être après 22h (coucher de soleil tardif, et Isha nécessite 17° sous l'horizon)
- **Hiver :** Isha est vers 20h (coucher de soleil plus précoce)

C'est correct selon la méthode Habous et correspond aux horaires des mosquées.

### Puis-je utiliser WaqtSalat dans d'autres pays ?

WaqtSalat est optimisé pour le Maroc utilisant la méthode Habous. Bien que vous puissiez ajuster manuellement les horaires, les angles de calcul sont spécifiques au Maroc.

Pour d'autres pays, considérez des applications qui supportent plusieurs méthodes de calcul.

---

## Vous Avez Encore des Questions ?

- Parcourez notre [Blog](/posts/) pour des guides détaillés
- Consultez les horaires de prière par ville : [Rabat](/cities/rabat/), [Casablanca](/cities/casablanca/), [Marrakech](/cities/marrakech/)
- Visitez [WaqtSalat](https://waqtsalat.github.io/waqtsalat/) pour utiliser l'application
