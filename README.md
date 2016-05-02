# TreeView
TreeView pour PureBasic

**Licence d'utilisation :**

La licence est de type **CC-BY** 

+ Vous pouvez copier, modifier le code du module librement.
+ Vous ne pouvez pas commercialiser le module **Maxilist** en lui-même
+ Par contre vous pouvez commercialiser, tous logiciels de votre conception qui utilise le module **Maxilist** librement.
+ Vous devez spécifier dans votre licence finale l'utilisation du module **Maxilist** ainsi que le nom de son concepteur (**Microdevweb**)

**Tree est une module de gestion de listes multiples.**

**Consultez lz manuel du développeur**

**Lexique**
+ [Initialisation](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#initialisation)
  + [Create](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#createidxiyiwihi)
+ [Ajout d'éléments](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#additemidtreepositiontextimage0nivels0)
  + [AddItem](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#additemidtreepositiontextimage0nivels0)
+ [Paramétrage de l'arbre](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#param%C3%A9trage-de-larbre)
  + [SetIconeImage](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#seticoneimageidtreeicoepandeicocollapseicocheckonicocheckof)
  + [SetIconSize](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#seticonsizeidtreeexpandsizecheckboxsizeiconesize)
  + [SetGeneralSize](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#setgeneralsizeidtreeheightlineleftmarginupmarginmarginlinehitemoffset)
  + [SetColor](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#setcoloridtreebgcolorfgcolorselectbgcolorselectfgcolorlinecolor)
+ [Paramétrage des éléments](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#param%C3%A9trage-des-%C3%A9l%C3%A9ments)
  + [SetData](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#setdataidtreeitemtypevalue)
  + [DisableCheckBox](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#disablecheckboxidtreeitemstateb)
  + [DisableModeSelect](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#disablemodeselectidtree)
  + [DisableItemSelected](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#disableitemselectedidtreeitemstateb)
+ [Ajout de boutons de contrôle](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#ajout-de-boutons-de-contr%C3%B4le)
   + [AddItemButton](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#additembuttonidtreeitemiconesizecallbackhelpmsgs)
   + [ChangeBtItem](https://github.com/microdevweb/TreeView/wiki/Manuel-du-d%C3%A9veloppeur#changebtitemidtreeitembuttoniconesizecallback)
