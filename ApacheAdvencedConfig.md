## INTRODUCTION A LA CONFIGURATION D'APACHE ##

Une des raisons du succès d’apache est, entre autres, sa souplesse d’utilisation. Malheureusement, la documentations Apache est plutôt sibylline en matière d’optimisation et qui plus est, en anglais ce qui pousse pas mal de webmaster à jouer aux apprentis sorciers avec le paramétrage d’apache. 
J'ai potassé les docs apaches ce week-end et rcherché quelques notes dans mes cahiers pour essayer de vous aider à y voir plus clair en détaillant les principaux paramètres de configuration d’apache en matière de performances (je ne parle que des paramètres commun à tous les serveurs web indépendamment de tel ou tel module apache). Ne vous attendez cependant pas à ce que je vous donne une configuration type car cela n’existe pas ! 
La configuration correcte des paramètres:
* **MinSpareServers**
* **MaxSpareServers** 
* **StartServers** 
* **MaxClients** 
* **MaxRequestsPerChild**

est primordiale pour fixer les performance d’apache.  **Il n’y a aucune valeur universelle pour ces valeurs qui dépendent uniquement des ressources et de l'utilisation de votre serveur**. 
**La ressource la plus importante car la plus limitative de votre serveur est la mémoire**. C’est la quantité de mémoire de votre serveur qui pose une limite physique au nombre de connections simultanées. Le paramètre permettant de fixer le nombre maximum de clients que apache peut servir en même temps est MaxClients. 

### MaxClients ###
Pour déterminer la valeur de MaxClient il faut tout d’abord estimer la quantité de mémoire que vous souhaitez allouer à apache. Un bon moyen d’estimer cette quantité de mémoire et d’arrêter apache et de faire un **"ps - aux"**. On fait alors la somme de la colonne RSS, que l’on soustrait à la quantité de mémoire du serveur. Par sécurité, on diminue la valeur obtenue de 10%. 
Par exemple, nous obtenons 720Mo. 
Maintenant nous allons déterminer la taille d’un processus apache. Apache étant en fonctionnement, avec la commande **"ps aux | grep apache"** on fait la moyenne de la colonne RSS. (Selon le serveur, apache peut s’exécuter sous différents utilisateurs : http, apache, apache2, www-data etc…) Nous obtenons 14Mo. 
La division **720/14 nous donne 51**. C’est la valeur de notre MaxClients pour notre serveur. 
Si vous mettez une valeur inférieure, vous sous utilisez vos ressources, une valeur supérieure risque d’obliger votre serveur à swapper lorsque les 51 clients seront atteint dans le pire des cas ou dans le meilleur des cas, les clients supplémentaires seront mis en attente ce qui ralentira l'accés à votre serveur. 
Si vous trouvez que cette valeur est insuffisante par rapport à vos besoins, il faut travailler la taille de vos processus apache. Par exemple, un processus apache sans php pèse environ 3 à 4 Mo. Avec php il peut atteindre 20 Mo ! Par défaut, dans php.ini, vous allouez 8Mo à chaque script. Il peut être intéressant de diminuer cette valeur en faisant quelques tests. Par exemple, si vous gagnez 2Mo cela se traduira par une valeur de 720/12=60 pour MaxClients. 

Attention ! au dela de 256, il faut recompiler apache sinon cette valeur ne sera pas prise en compte et restera limité a 256. 

Comment savoir si on a dépassé la valeur allouée à MaxClients ? En regardant dans le fichier des log d’erreur. Un dépassement de [b]MaxClients [/b]est signale par une ligne de ce type : 

<pre> [error] server reached MaxClients settings, consider raising the MaxClients setting </pre>


### MaxRequestsPerChild ### 
Ce paramètre fixe la limite du nombre de demandes qu'un processus apache satisfera en générant un processus fils avant de mourir. Il faut savoir qu’un processus fils consomme plus de mémoire après chaque demande. 
* Si MaxRequestsPerChild vaut 0, alors le processus ne meurt jamais, sa taille augmente au fur est en mesure des demandes et vous vous retrouvez avec la mémoire du serveur saturée et apache qui ne réponds pratiquement plus. 
* Si MaxRequestsPerChild vaut 1, alors le processus meurt après chaque service. Le nouveau processus crée pour repondre au client utilise un minimum de mémoire mais en contrepartie, sa génération est plus lente. 

Le choix de cette valeur est un compromis entre **l’utilisation mémoire et la vitesse d’exécution**. Moins votre contenu est dynamique, plus haute peut être la valeur de ce paramètre. Si la valeur est trop faible, vous consommerais beaucoup de CPU pour créer des processus, si elle est trop élevée vous verrez augmenter la taille de vos processus apache. Gardez à l’esprit que plus vos processus apache sont lourds plus vous serez emmené à réduire le MaxClients. 

Pour déterminer la valeur la plus appropriée il vous faudra faire des tests de valeurs entre 50 et 1000 selon votre utilisation du serveur. Lors d’une commande "ps aux –sort :rss" observez la durée de vie de vos processus apache et considérez en regard la taille des processus, cela vous donnera des pistes. 

**MinSpareServers, MaxSpareServers et StartServers sont seulement importants pour déterminer les temps de réponses vis-à-vis des clients**

### StartServers ### 
Défini le nombre de processus crées par apache lors de son lancement. Sur certaine config, apache n’est « jamais » redémarré ce qui rend ce paramètre insignifiant. Si apache est redémarré fréquemment, cette valeur doit être suffisante pour servir le nombre de clients au moment du lancement d’apache. 

### MinSpareServers et  MaxSpareServers ###
Fixent les limites basse et haute en nombre de processus dormant (sleeping) qu’apache doit maintenir. Si ce nombre de processus dépasse MaxSpareServers, les processus en trop seront tués, si ce nombre est inférieur à MinSpareServers, les processus manquants seront crées. 
La création de processus étant gourmande en mémoire, ne réglez pas ces valeurs trop bas. Mais la encore, votre serveur est unique et il vous faudra effectuer des test. Un bon moyen de trouver les bonnes valeurs est de régler ces paramètres de façon à ce qu’apache n’ai pas à créer plus de 4 processus enfant par seconde. Vous allez me dire mais comment on le sait ! 8O 

C’est simple, si apache crée plus de 4 processus enfant par seconde vous aurez un message dans les logs d’erreur. 
<pre> :wink: </pre> 

Mais ne vous focalisez pas sur ces deux valeurs qui ne sont pas critiques. 
* **MinSspareServers**:  doit être assez haut pour absorber un pic de requêtes
* **MaxSpareServers**: doit être assez haut pour couvrir les fluctuations normales du nombre de requêtes. 
Leur limite étant bien sur **MaxClients** 

Il nous reste deux paramètre de configuration concernant le gestion des processus apache:

## KeepAlive ##
Permet d’autoriser l’envoie de requêtes multiples sur la même connexion TCP. Cela peut être utile si vos pages HTML contiennent beaucoup d’images car si KeepAlive est positionné à Off, une connexion TCP séparée est crée pour chacune des images. Là encore, le type d’utilisation du serveur déterminera votre choix. Mais gardez à l’esprit que les images communes à plusieurs pages web consultés sont mise en cache par le navigateur de l’utilisateur. 

## KeepAliveTimeout ##
Détermine la durée d’attente de la prochaine requête. Si cette valeur est trop élevée, vos processus enfant sont immobilisés en état d’attente au lieu de servir les requêtes. Personnellement je conseille entre 2 et 5 secondes pour cette valeur. 
