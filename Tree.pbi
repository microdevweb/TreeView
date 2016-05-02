;**************************************************************************************************************
; © MicrodevWeb   http://www.microdevweb.com
; Name: Tree Module
; Vers: 1.0 Create:2015.06.30 Finished: 2015.07.01
; Vers: 1.1 Create: 2015.07.01 Finished: 2015.07.01
; --> AddDropCallBack(idTree,*CallBack)
; Vers: 1.2 Create: 2015.07.01 Finished: 2015.07.03
; --> ClearItem(idTree)
; --> Corection de bug
;--> SetLine(idTree,On.b,Mode.i)
; --> DisableCheckBox(idTree,item,State.b)
; --> DeselectAllItem(idTree)
; --> SelectItem(idTree,item,State.b)
; --> GetItemSelected(idTree)
; --> ChangeIcoItem(idTree,item,Icone)
; --> ChangeBtItem(idTree,item,button,icone,size,*callBack)
; Vers: 1.3 Create: 2015.07.03 Finished: 2015.07.03
; --> GetTypeParent(idTree,item,Position)
; --> GetValueParent(idTree,item,Position)
; Vers 1.4 
; --> GetPositionToValue(idTree,Value)
; Vers 1.5
; --> GetTextValue(idTree,item)
; --> GetPositionToText(idTree,Text$)
; --> AddHelp(idTree,TypeItem,HelpTitle$,HelpMsg$)
; Vers 1.6
; --> SetCallbackExpand(idTree,*ProcedureCallback)
; Vers 1.7
; --> Disable AddHelp(idTree,TypeItem,HelpTitle$,HelpMsg$)
; --> Add SetCallbackHoverText(idTree,*ProcedureCallback)
; --> ADD SetCallbackHoverIcon(idTree,*ProcedureCallback)
; --> ADD SetCallbackHoverButton(idTree,*ProcedureCallback)
; Vers 1.8
; --> SetItemChecked(idTree,item,State.b)
; Vers 1.9
; --> DisableModeSelect(idTree)
; Vers 2.0
; --> MOD AddItemButton(idTree,item,icone,size,*callBack,HelpMsg.s)
;--> ajout d'une bule d'aide au bouton
;**************************************************************************************************************
DeclareModule Tree
      #full=0
      #Dootted=1
      Declare  Create(id,X.i,Y.i,W.i,H.i)
      Declare Draw(id=-1)
      Declare AddItem(idTree,Position,Text$,Image=0,Nivels=0)
      Declare SetData(idTree,item,type,value)
      Declare GetDataType(idTree,item)
      Declare GetDataValue(idTree,item)
      Declare GetItemSelected(idTree)
      Declare$ GetItemChecked(idTree)
      Declare SetCallBackSelected(idTree,*CallBack)
      Declare CountItem(idTree)
      Declare SetIconeImage(idTree,IcoEpande,IcoCollapse,IcoCheckOn,IcoCheckOf)
      Declare SetIconSize(idTree,expandSize,checkboxSize,iconeSize)
      Declare SetGeneralSize(idTree,HeightLine,LeftMargin,UpMargin,marginLineH,ItemOffset)
      Declare SetColor(idTree,BgColor,FgColor,SelectBgColor,SelectFgColor,LineColor)
      Declare  SetCallBackCheckBox(idTree,*CallBack)
      Declare AddItemButton(idTree,item,icone,size,*callBack,HelpMsg.s="")
      Declare Free(idTree)
      Declare GetIdGadget(idTree)
      Declare AddDropCallBack(idTree,*CallBack)
      Declare ClearItem(idTree)
      Declare SetLine(idTree,On.b,Mode.i)
      Declare DisableCheckBox(idTree,item,State.b)
      Declare DeselectAllItem(idTree)
      Declare SelectItem(idTree,item,State.b)
      Declare GetItemSelected(idTree)
      Declare ChangeIcoItem(idTree,item,Icone)
      Declare ChangeBtItem(idTree,item,button,icone,size,*callBack)
      Declare GetTypeParent(idTree,item,Position)
      Declare GetValueParent(idTree,item,Position)
      Declare GetPositionToValue(idTree,Value)
      Declare ExpandAll(idTree)
      Declare$ GetTextValue(idTree,item)
      Declare GetPositionToText(idTree,Text$)
      Declare SetCallbackExpand(idTree,*ProcedureCallback)
      Declare SetExpand(idTree,item,State.b)
      Declare SetCallbackHoverText(idTree,*ProcedureCallback)
      Declare SetCallbackHoverIcon(idTree,*ProcedureCallback)
      Declare SetCallbackHoverButton(idTree,*ProcedureCallback)
      Declare SetItemChecked(idTree,item,State.b)
      Declare DisableModeSelect(idTree)
      Declare DisableItemSelected(idTree,item,State.b)
      Declare InitEvent(id_tree)
      Declare HideTreeHelp(idTree)
EndDeclareModule
Module Tree
;       EnableExplicit
      UsePNGImageDecoder()
      ;-* Constantes
      #Title="Tree module vers 1.5"
      ;}
      ;-* Global Variables
      Global gMouseX,gMouseY,gBoqued.b=#True
      Global HelpFont=LoadFont(#PB_Any,"Arial",11,#PB_Font_HighQuality)
      Global gIdHelp=-1,*gHelpOn=-1,gIdBalloon
      ;}
      ;-* Structure
      Structure Pos
            X.i
            Y.i
            W.i
            H.i
            *id
            SelectOn.b
      EndStructure
      Structure button
            X.i
            Y.i
            image.i
            *callBack
            size.i
            HelpMsg.s
      EndStructure
      Structure Items
            Nivels.i
            Text$
            Type.i
            Value.i
            CheckBoxOn.b
            Ckecked.b
            Icone.i
            DeleteOn.i
            EditOn.i
            Expanded.b
            SelectOn.b
            Selected.b
            X.i
            Y.i
            W.i
            List myButton.button()
      EndStructure
      Structure Parameters
            BgColor.i
            FgColor.i
            LineColor.i
            Font.i
            ItemOffset.i
            CheckBoxSize.i
            IconSize.i
            NodeSize.i
            SelectBgColor.i
            SelectFgColor.i
            LeftMargin.i
            UpMargin.i
            Height.i
            ExpandSize.i
            marginLineH.i
      EndStructure
      Structure help
            Title$
            msg$
            TypeItem.i
            Id.i
      EndStructure
      Structure Tree
            X.i
            Y.i
            W.i
            H.i
            WC.i
            HC.i
            myParamaters.Parameters
            List myItems.Items()
            idScrollArea.i
            idCanvas.i
            CurrentExpand.i
            CurrentCheckBox.i
            CurrentIcone.i
            CurrentTxt.i
            CurrentButton.i
            List  myExpand.Pos()
            List myCheckBox.Pos()
            List myIcon.Pos()
            List myTxt.Pos()
            *CallBackSelected
            *CallBackCheckBox
            *CallBackDrop
            *CallBackExpand
            *CallBackHoverText
            *CallBackHoverIcon
            *CallBackHoverButton
            imgCheckOn.i
            imgCheckOf.i
            imgExpand.i
            imgCollabse.i
            MW.i
            MH.i
            IdWindow.i
            LastNivels.i
            LineOn.b
            LineMode.i
            Map myHelp.help()
            modeSelectOn.b
            IdHelpWin.i
            HelpOn.b
      EndStructure
      ;}
      ;-* List Map
      Global NewMap myTree.Tree()
      Global NewMap myExpand.b()
      Global Font=LoadFont(#PB_Any,"Arial",12,#PB_Font_HighQuality)
      ;}
      Prototype.l ProtoEventSelect(Type.i,Value.i)
      Prototype$ ProtoEventCheckBox(checked$)
      Prototype$ ProtoEventDrop(Result$)
      Prototype$ ProtoEventExpand(Expanded$,Folded$)
      Prototype.l ProtoHover(Type.i,Value.i,Id.i,*CallBack=-1)
      Declare Draw(id=-1)
      Declare Resize()
      Declare FindMap(id,Requiered.b=#True)
      ;-* Function
      Procedure HOverExpand()
            ForEach myTree()\myExpand()
                  myTree()\CurrentExpand=-1
                  With myTree()\myExpand()
                        If (gMouseX>=\X And gMouseX<=\X+\W) And (gMouseY>=\Y And gMouseY<=\Y+\H)
                              myTree()\CurrentExpand=@myTree()\myExpand()
                              ProcedureReturn #True
                        EndIf
                  EndWith
            Next
            ProcedureReturn #False
      EndProcedure
      Procedure HoverCheckBox()
            myTree()\CurrentCheckBox=-1
            ForEach myTree()\myCheckBox()
                  With myTree()\myCheckBox()
                        If (gMouseX>=\X And gMouseX<=\X+\W) And (gMouseY>=\Y And gMouseY<=\Y+\H)
                              myTree()\CurrentCheckBox=@myTree()\myCheckBox()
                              ProcedureReturn #True
                        EndIf
                  EndWith
            Next
            ProcedureReturn #False
      EndProcedure
      Procedure HoverIcon()
            Protected myProcedure.ProtoHover
            myTree()\CurrentIcone=-1
            If myTree()\modeSelectOn=#False:ProcedureReturn #False:EndIf
            ForEach myTree()\myIcon()
                  With myTree()\myIcon()
                      If \SelectOn
                          If (gMouseX>=\X And gMouseX<=\X+\W) And (gMouseY>=\Y And gMouseY<=\Y+\H)
                              myTree()\CurrentIcone=@myTree()\myIcon()
                              ChangeCurrentElement(myTree()\myItems(),myTree()\myIcon()\id)
                              ;                               gIdHelp=myTree()\myItems()\Type
                              ;                               DisplayHelp()
                              If myTree()\CallBackHoverIcon<>-1
                                  myProcedure=myTree()\CallBackHoverIcon
                                  myProcedure(myTree()\myItems()\Type,myTree()\myItems()\Value,ListIndex(myTree()\myItems()))
                              EndIf
                              ProcedureReturn #True
                          EndIf
                      EndIf
                  EndWith
            Next
            ProcedureReturn #False
      EndProcedure
      Procedure HoverTxt()
            Protected myProcedure.ProtoHover
            myTree()\CurrentTxt=-1
            If myTree()\modeSelectOn=#False:ProcedureReturn #False:EndIf
            ForEach myTree()\myTxt()
                With myTree()\myTxt() 
                    If \SelectOn
                        If (gMouseX>=\X And gMouseX<=\X+\W) And (gMouseY>=\Y And gMouseY<=\Y+\H)
                            myTree()\CurrentTxt=@myTree()\myTxt()
                            ChangeCurrentElement(myTree()\myItems(),myTree()\myTxt()\id)
                            ;                               gIdHelp=myTree()\myItems()\Type
                            ;                               DisplayHelp()
                            If myTree()\CallBackHoverText<>-1
                                myProcedure=myTree()\CallBackHoverText
                                myProcedure(myTree()\myItems()\Type,myTree()\myItems()\Value,ListIndex(myTree()\myItems()))
                            EndIf
                            ProcedureReturn #True
                        EndIf
                    EndIf
                  EndWith
            Next
            ProcedureReturn #False
      EndProcedure
      Procedure HideTreeHelp(idTree)
           If Not FindMap(idTree):ProcedureReturn #False:EndIf   
           HideWindow(myTree()\IdHelpWin,#True,#PB_Window_NoActivate)
           Delay(50)
            myTree()\HelpOn=#False
      EndProcedure
      Procedure HideHelp()
          HideWindow(myTree()\IdHelpWin,#True,#PB_Window_NoActivate)
          myTree()\HelpOn=#False
      EndProcedure
      Procedure  DisplayHelp()   
          Protected  X,Y,W,H
          ExamineDesktops()
          With myTree()\myItems()\myButton()
              StartDrawing(WindowOutput(myTree()\IdHelpWin))
              DrawingFont(FontID(Font))
              W=TextWidth(\HelpMsg)+20
              H=TextHeight(\HelpMsg)+20
              X=DesktopMouseX()
              Y=DesktopMouseY()
              Y+20
              If (X+W)>DesktopWidth(0)
                  X=DesktopWidth(0)-(W+30)
              EndIf
              If (Y+H)>DesktopHeight(0)
                  Y=DesktopHeight(0)-(H+30)
              EndIf
              ResizeWindow(myTree()\IdHelpWin,X,Y,W,H)
              DrawingMode(#PB_2DDrawing_Default)
              Box(0,0,W,H,RGB(102, 179, 255))
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(0,0,W,H,RGB(0, 59, 118))
              DrawingMode(#PB_2DDrawing_Transparent)
              DrawText(10,10,\HelpMsg,RGB(0, 0, 0))
              StopDrawing()
              If Not myTree()\HelpOn
                  HideWindow(myTree()\IdHelpWin,#False,#PB_Window_NoActivate)
                  myTree()\HelpOn=#True
              EndIf
          EndWith
      EndProcedure
      Procedure HoverButton()
            Protected myProcedure.ProtoHover
            myTree()\CurrentButton=-1
            ForEach myTree()\myItems()
                  ForEach myTree()\myItems()\myButton()
                        With myTree()\myItems()\myButton()
                              If (gMouseX>=\X And gMouseX<=\X+\size) And (gMouseY>=\Y And gMouseY<=\Y+\size)
                                    myTree()\CurrentButton=@myTree()\myItems()\myButton()
                                    If \HelpMsg<>""
                                        DisplayHelp()   
                                    EndIf
                                    If myTree()\CallBackHoverButton<>-1
                                          myProcedure=myTree()\CallBackHoverButton
                                          myProcedure(myTree()\myItems()\Type,myTree()\myItems()\Value,ListIndex(myTree()\myItems()),\callBack)
                                    EndIf
                                    ProcedureReturn #True
                              EndIf
                        EndWith
                  Next
              Next
              If myTree()\HelpOn
                  HideHelp()
              EndIf
            ProcedureReturn #False
      EndProcedure
      Procedure WhereIsMouse()
            gIdHelp=-1
            If HOverExpand()
                  SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
                  ProcedureReturn 
            EndIf
            If HoverCheckBox()
                  SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
                  ProcedureReturn 
            EndIf
            If HoverIcon()
                  SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
                  ProcedureReturn 
            EndIf
            If HoverTxt()
                  SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
                  ProcedureReturn 
            EndIf
            If HoverButton()
                  SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
                  ProcedureReturn 
            EndIf
            SetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Default)
      EndProcedure
      Procedure SendCallBackExpand()
            Protected myProcedure.ProtoEventExpand
            myProcedure=myTree()\CallBackExpand
            Protected expanded$,foldes$,N
            PushListPosition(myTree()\myItems())
            ForEach myTree()\myItems()
                  With myTree()\myItems()
                        If \Expanded
                              expanded$+ListIndex(myTree()\myItems())+"@"
                        Else
                              foldes$+ListIndex(myTree()\myItems())+"@"
                        EndIf
                  EndWith
                  N+1
            Next
            PopListPosition(myTree()\myItems())
            myProcedure(expanded$,foldes$)
      EndProcedure
      Procedure ManageExpand()
            If myTree()\CurrentExpand=-1 :ProcedureReturn #False : EndIf
            If ListSize(myTree()\myExpand())=0:ProcedureReturn :EndIf
            ChangeCurrentElement(myTree()\myExpand(),myTree()\CurrentExpand)
            ChangeCurrentElement(myTree()\myItems(),myTree()\myExpand()\id)
            With myTree()\myItems()
                  If \Expanded
                        \Expanded=#False
                  Else
                        \Expanded=#True
                  EndIf
                  If myTree()\CallBackExpand<>-1
                        SendCallBackExpand()
                  EndIf
                  FindMapElement(myExpand(),Str(ListIndex(myTree()\myItems())))
                  myExpand()=\Expanded
                  Draw()
            EndWith
      EndProcedure
      Procedure CallBackCheckBox()
            If myTree()\CallBackCheckBox=-1:ProcedureReturn :EndIf
            Protected EventCheckBox,txt$
            EventCheckBox.ProtoEventCheckBox=myTree()\CallBackCheckBox
            ForEach myTree()\myItems()
                  If myTree()\myItems()\Ckecked
                        If txt$<>""
                              txt$+Chr(10)
                        EndIf
                        txt$+ListIndex(myTree()\myItems())
                  EndIf
            Next
            EventCheckBox(txt$)
      EndProcedure
      Procedure ManageCheckBox()
            Protected state.b,Parent
            If myTree()\CurrentCheckBox=-1 :ProcedureReturn #False : EndIf
            ChangeCurrentElement(myTree()\myCheckBox(),myTree()\CurrentCheckBox)
            ChangeCurrentElement(myTree()\myItems(),myTree()\myCheckBox()\id)
            With myTree()\myItems()
                  If \Ckecked
                        \Ckecked=#False
                        state=#False
                  Else
                        \Ckecked=#True
                        state=#True
                  EndIf
                  Parent=\Nivels
                  ;Recherche les enfant, en les placer au même état
                  While NextElement(myTree()\myItems())
                        If \Nivels>Parent
                              \Ckecked=state
                        Else
                              Break
                        EndIf
                  Wend
                  Draw()
            EndWith
            CallBackCheckBox()
      EndProcedure
      Procedure CallBackSelected()
            If myTree()\CallBackSelected=-1 :ProcedureReturn :EndIf
            Protected EventSelect
            EventSelect.ProtoEventSelect=myTree()\CallBackSelected
            With myTree()\myItems()
                  EventSelect(\Type,\Value)
            EndWith
      EndProcedure
      Procedure ManageIcon()
          If myTree()\CurrentIcone=-1 :ProcedureReturn #False : EndIf
          If myTree()\modeSelectOn=#False :ProcedureReturn #False : EndIf
            ForEach myTree()\myItems()
                  myTree()\myItems()\Selected=#False
            Next 
            ChangeCurrentElement(myTree()\myIcon(),myTree()\CurrentIcone)
            ChangeCurrentElement(myTree()\myItems(),myTree()\myIcon()\id)
            With myTree()\myItems()
                If \SelectOn=#True
                  \Selected=#True
                  CallBackSelected()
                  Draw()
              EndIf
            EndWith
      EndProcedure
      Procedure ManageTxt()
          If myTree()\CurrentTxt=-1 :ProcedureReturn #False : EndIf
          If myTree()\modeSelectOn=#False :ProcedureReturn #False : EndIf
            ForEach myTree()\myItems()
                  myTree()\myItems()\Selected=#False
            Next 
            ChangeCurrentElement(myTree()\myIcon(),myTree()\CurrentTxt)
            ChangeCurrentElement(myTree()\myItems(),myTree()\myTxt()\id)
            With myTree()\myItems()
                If \SelectOn=#True
                    \Selected=#True
                    CallBackSelected()
                    Draw()
                EndIf
            EndWith
      EndProcedure
      Procedure ManageButton()
            If myTree()\CurrentButton=-1:ProcedureReturn :EndIf
            Protected EventButton
            ChangeCurrentElement(myTree()\myItems()\myButton(),myTree()\CurrentButton)
            EventButton.ProtoEventSelect=myTree()\myItems()\myButton()\callBack
            EventButton(myTree()\myItems()\Type,myTree()\myItems()\Value)
      EndProcedure
      Procedure ManageLeftClick()
            ManageExpand()
            ManageCheckBox()
            ManageIcon()
            ManageTxt()
            ManageButton()
      EndProcedure
      Procedure Event()
            Protected X1,X2,Y1,Y2,W,H
            Select EventType()
                  Case #PB_EventType_MouseLeave
                  Case #PB_EventType_MouseEnter
                        FindMapElement(myTree(),Str(GetGadgetData(EventGadget())))
                  Case #PB_EventType_MouseMove
                        gMouseX=GetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_MouseX)
                        gMouseY=GetGadgetAttribute(myTree()\idCanvas,#PB_Canvas_MouseY)
                        WhereIsMouse()
                  Case #PB_EventType_LeftClick
                        ManageLeftClick()  
                  Case #PB_EventType_MouseLeave
                        *gHelpOn=-1
                        SendMessage_(gIdBalloon, #TTM_POP,0, 0)
                        SendMessage_(gIdBalloon, #TTM_ACTIVATE,0,0)
            EndSelect
      EndProcedure
      Procedure FindMap(id,Requiered.b=#True)
            Protected Res=FindMapElement(myTree(),Str(id))
            If Requiered And Res=0
                  MessageRequester(#Title,"Error this tree not exist...")
            EndIf
            If Not Requiered And Res>0
                  MessageRequester(#Title,"Error this tree already exist...")
            EndIf
            If Res=0:ProcedureReturn #False:EndIf               
            If Res>0:ProcedureReturn #True:EndIf   
      EndProcedure
      Procedure InitParameters()
            With myTree()\myParamaters
                  \BgColor=$F5F5F5
                  \FgColor=$000000
                  \CheckBoxSize=16
                  \IconSize=24
                  \ItemOffset=30
                  \LineColor=$ED9564
                  \Font=LoadFont(#PB_Any,"Arial",11,#PB_Font_HighQuality)
                  \SelectBgColor=$BD461A
                  \SelectFgColor=$FFFFFF
                  \LeftMargin=10
                  \UpMargin=10
                  \Height=40
                  \ExpandSize=20
                  \marginLineH=10
                  SetGadgetColor(myTree()\idScrollArea,#PB_Gadget_BackColor,\BgColor)
            EndWith
      EndProcedure
      Procedure DrawButton(X,Y)
            ForEach myTree()\myItems()\myButton()
                  With  myTree()\myItems()\myButton()
                        DrawingMode(#PB_2DDrawing_AlphaClip)
                        X+5
                        DrawImage(ImageID(\image),X,Y,\size,\size)
                        \X=X
                        \Y=Y
                        If myTree()\MW<X+\size
                              myTree()\MW=X+\size
                        EndIf
                        X+5+\size
                  EndWith
            Next
      EndProcedure
      Procedure DrawLine(X1,Y1,X2,Y2,Color)
            Protected X,Y
            If myTree()\LineOn=#False:ProcedureReturn :EndIf
            DrawingMode(#PB_2DDrawing_Default)
            Select myTree()\LineMode
                  Case #Dootted
                        For X=X1 To X2
                              For Y=Y1 To Y2
                                    Plot(X,Y,Color)
                                    Y+5
                              Next
                              X+5
                        Next
                  Case #full
                        LineXY(X1,Y1,X2,Y2,Color)
            EndSelect
      EndProcedure
      Procedure DrawItem()
            Protected  X,Y,W,H,Y2,X2,CurentNivels,Child.b,Parent=-1,WT,LineDraw.b=#False,Expanded.b
            Protected Color=myTree()\myParamaters\LineColor,Comp
            X=myTree()\myParamaters\LeftMargin
            Y=myTree()\myParamaters\UpMargin
            H=myTree()\myParamaters\Height
            ClearList(myTree()\myExpand())
            ClearList(myTree()\myCheckBox())
            ClearList(myTree()\myIcon())
            ClearList(myTree()\myTxt())
            ForEach myTree()\myItems()
                  LineDraw=#False
                  ;Regarde si le parent est collabsed, si oui saute tout les enfants
                  DrawingMode(#PB_2DDrawing_AlphaClip)
                  With myTree()\myItems()                      
                        PushListPosition(myTree()\myItems())
                        If PreviousElement(myTree()\myItems())>0
                              If \Expanded=#False
                                    Parent=\Nivels
                              EndIf
                        EndIf
                        PopListPosition(myTree()\myItems())
                        If Parent>-1
                              While  \Nivels>Parent
                                    If NextElement(myTree()\myItems())=0
                                          ProcedureReturn 
                                    EndIf
                              Wend
                              Parent=-1
                        EndIf
                        X2=X+(\Nivels * myTree()\myParamaters\ItemOffset)                       
                        ;On regarde si l'item suivant est un niveau  en dessous
                        Child=#False
                        CurentNivels=\Nivels
                        PushListPosition(myTree()\myItems())
                        If NextElement(myTree()\myItems())>0
                              If \Nivels>CurentNivels
                                    Child=#True
                              EndIf
                        EndIf
                        PopListPosition(myTree()\myItems())
                        If Child
                              W=myTree()\myParamaters\ExpandSize
                              Y2=(Y+(H/2))-(W/2)
                              Expanded=\Expanded
                              If \Expanded
                                    DrawImage(ImageID(myTree()\imgCollabse),X2,Y2,W,W)
                              Else
                                    DrawImage(ImageID(myTree()\imgExpand),X2,Y2,W,W)
                              EndIf
                              AddElement(myTree()\myExpand())
                              myTree()\myExpand()\X=X2
                              myTree()\myExpand()\Y=Y2
                              myTree()\myExpand()\W=W
                              myTree()\myExpand()\H=W
                              myTree()\myExpand()\id=@myTree()\myItems()
                              \X=X2
                              \Y=Y2
                              \W=W
                              ;Dessin de la ligne 
                              If LineDraw=#False
                                    Comp=\Nivels
                                    PushListPosition(myTree()\myItems())
                                    While   PreviousElement(myTree()\myItems())
                                          If \Nivels<Comp
                                                DrawLine( \X+(\W/2),Y2+(\W/2),X2,Y2+(\W/2),Color) 
                                                DrawLine(\X+(\W/2),\Y+(\W),\X+(\W/2),Y2+(\W/2),Color)
                                                LineDraw=#True
                                                Break                                                
                                          EndIf
                                    Wend 
                                    PopListPosition(myTree()\myItems())
                              EndIf
                              X2+W+5
                        EndIf
                        W=myTree()\myParamaters\CheckBoxSize
                        Y2=(Y+(H/2))-(W/2)
                        DrawingMode(#PB_2DDrawing_AlphaClip)
                        If \CheckBoxOn
                              If \Ckecked
                                    DrawImage(ImageID(myTree()\imgCheckOn),X2,Y2,W,W)
                              Else
                                    DrawImage(ImageID(myTree()\imgCheckOf),X2,Y2,W,W)
                              EndIf
                              AddElement(myTree()\myCheckBox())
                              myTree()\myCheckBox()\X=X2
                              myTree()\myCheckBox()\Y=Y2
                              myTree()\myCheckBox()\W=W
                              myTree()\myCheckBox()\H=W
                              myTree()\myCheckBox()\id=@myTree()\myItems()
                              ;Dessin de la ligne 
                              If LineDraw=#False
                                    Comp=\Nivels
                                    PushListPosition(myTree()\myItems())
                                    While  PreviousElement(myTree()\myItems())
                                          If \Nivels<Comp
                                                DrawLine( \X+(\W/2),Y2+(\W/2),X2,Y2+(\W/2),Color) 
                                                DrawLine(\X+(\W/2),\Y+(\W),\X+(\W/2),Y2+(\W/2),Color)
                                                LineDraw=#True
                                                Break                                                
                                          EndIf
                                    Wend
                                    PopListPosition(myTree()\myItems())
                              EndIf
                              
                              If \X=0 And \Y=0
                                    \X=X2
                                    \Y=Y2
                                    \W=W
                              EndIf
                              X2+W+5
                        EndIf
                        If \Icone>0
                              DrawingMode(#PB_2DDrawing_AlphaClip)
                              W=myTree()\myParamaters\IconSize
                              Y2=(Y+(H/2))-(W/2)
                              DrawImage(ImageID(\Icone),X2,Y2,W,W)
                              ;Dessin de la ligne 
                              If LineDraw=#False
                                    Comp=\Nivels
                                    PushListPosition(myTree()\myItems())
                                    While   PreviousElement(myTree()\myItems())
                                          If \Nivels<Comp
                                                DrawLine( \X+(\W/2),Y2+(\W),X2,Y2+(\W),Color) 
                                                DrawLine(\X+(\W/2),\Y+(\W),\X+(\W/2),Y2+(\W),Color)
                                                LineDraw=#True
                                                Break                                                
                                          EndIf
                                    Wend 
                                    PopListPosition(myTree()\myItems())
                              EndIf
                              AddElement(myTree()\myIcon())
                              myTree()\myIcon()\X=X2
                              myTree()\myIcon()\Y=Y2
                              myTree()\myIcon()\W=W
                              myTree()\myIcon()\H=W
                              myTree()\myIcon()\id=@myTree()\myItems()
                              myTree()\myIcon()\SelectOn=\SelectOn
                              If \X=0 And \Y=0
                                    \X=X2
                                    \Y=Y2
                                    \W=W
                              EndIf
                              X2+W+5
                        EndIf
                        Protected fgColor
                        W=TextHeight(\Text$)
                        WT=TextWidth(\Text$)
                        Y2=(Y+(H/2))-(W/2)
                        If \Selected
                              fgColor=myTree()\myParamaters\SelectFgColor
                              DrawingMode(#PB_2DDrawing_Default)
                              Box(X2,Y2,WT,W,myTree()\myParamaters\SelectBgColor)
                        Else
                              fgColor=myTree()\myParamaters\FgColor
                        EndIf
                        DrawingMode(#PB_2DDrawing_Transparent)
                        DrawText(X2,Y2,\Text$,fgColor)
                        AddElement(myTree()\myTxt())
                        myTree()\myTxt()\X=X2
                        myTree()\myTxt()\Y=Y2
                        myTree()\myTxt()\W=WT
                        myTree()\myTxt()\H=W
                        myTree()\myTxt()\id=@myTree()\myItems()
                        myTree()\myTxt()\SelectOn=\SelectOn
                        ;Dessin de la ligne 
                        If LineDraw=#False
                              Comp=\Nivels
                              PushListPosition(myTree()\myItems())
                              While   PreviousElement(myTree()\myItems())
                                    If \Nivels<Comp
                                          DrawLine( \X+(\W/2),Y2+(\W/2),X2,Y2+(\W/2),Color) 
                                          DrawLine(\X+(\W/2),\Y+(\W),\X+(\W/2),Y2+(\W/2),Color)
                                          LineDraw=#True
                                          Break                                                
                                    EndIf
                              Wend 
                              PopListPosition(myTree()\myItems())
                        EndIf
                        ;Mémorise les valeurs MAX
                        If myTree()\MW<X2+WT+20
                              myTree()\MW=X2+WT+20
                        EndIf
                        If myTree()\MH<Y2+H+20
                              myTree()\MH=Y2+H+20
                        EndIf
                        If \X=0 And \Y=0
                              \X=X2
                              \Y=Y2
                              \W=W
                        EndIf
                        DrawButton(X2+WT,Y2)
                        X=myTree()\myParamaters\LeftMargin
                        Y+H
                  EndWith
            Next
      EndProcedure
      Procedure Resize()
            With myTree()
                  If \WC<\MW
                        SetGadgetAttribute(\idScrollArea,#PB_ScrollArea_InnerWidth,\MW)
                  Else
                        SetGadgetAttribute(\idScrollArea,#PB_ScrollArea_InnerWidth,\WC)
                  EndIf
                  If \HC<\MH
                        SetGadgetAttribute(\idScrollArea,#PB_ScrollArea_InnerHeight,\MH)
                  Else
                        SetGadgetAttribute(\idScrollArea,#PB_ScrollArea_InnerHeight,\HC)
                  EndIf
            EndWith
      EndProcedure
      Procedure Draw(id=-1)
            If id<>-1
                  If Not FindMap(id):ProcedureReturn #False:EndIf             
            EndIf
            With myTree()
                  \MW=0
                  \MH=0
                  StartDrawing(CanvasOutput(\idCanvas))
                  DrawingFont(FontID(\myParamaters\Font))
                  Box(0,0,GadgetWidth(\idCanvas),GadgetHeight(\idCanvas),\myParamaters\BgColor)
                  DrawItem()
;                   DrawLine()
                  StopDrawing()
                  Resize()
              EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure AddItem(idTree,Position,Text$,Image=0,Nivels=0)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf   
            Protected W,H
            With myTree()\myParamaters              
                  W=\LeftMargin+\IconSize+\ExpandSize+\CheckBoxSize 
                  H=\UpMargin
            EndWith
            AddElement(myTree()\myItems())
            With myTree()\myItems()
                  If FindMapElement(myExpand(),Str(ListIndex(myTree()\myItems())))=0
                        AddMapElement(myExpand(),Str(ListIndex(myTree()\myItems())))
                        myExpand()=#True
                        \Expanded=myExpand()
                  Else
                        \Expanded=myExpand()
                  EndIf
                  \CheckBoxOn=#True
                  \SelectOn=#True
                  \DeleteOn=#False
                  \EditOn=#False
                  \Text$=Text$
                  \Nivels=Nivels
                  If \Nivels>myTree()\LastNivels
                        myTree()\LastNivels=\Nivels
                  EndIf
                  If Image<>0
                        \Icone=CatchImage(#PB_Any,Image)
                  Else
                        \Icone=0
                  EndIf
                  W+myTree()\myParamaters\ItemOffset * \Nivels
                  StartDrawing(CanvasOutput(myTree()\idCanvas))
                  DrawingFont(FontID(myTree()\myParamaters\Font))
                  W+TextWidth(\Text$)+50
                  StopDrawing()
                  H+(ListSize(myTree()\myItems()) * myTree()\myParamaters\Height)+50
                  If W>GadgetWidth(myTree()\idCanvas)
                        ResizeGadget(myTree()\idCanvas,#PB_Ignore,#PB_Ignore,W,#PB_Ignore)
                  EndIf
                  If H>GadgetHeight(myTree()\idCanvas)
                        ResizeGadget(myTree()\idCanvas,#PB_Ignore,#PB_Ignore,#PB_Ignore,H)
                  EndIf
            EndWith
            
      EndProcedure
      Procedure InitEvent(id_tree)
;           If FindMap(id,#False):ProcedureReturn 0:EndIf
;           BindGadgetEvent(myTree()\idCanvas,@Event())
;           ProcedureReturn #True
      EndProcedure
      Procedure Create(id,X.i,Y.i,W.i,H.i)
            If id=#PB_Any
                id=0
                While FindMapElement(myTree(),Str(id))<>0
                    id+1
                Wend
            EndIf
            If FindMap(id,#False):ProcedureReturn 0:EndIf
            AddMapElement(myTree(),Str(id))
            With myTree()
                  \W=W
                  \H=H
                  \X=X
                  \Y=Y
                  \WC=W-5
                  \HC=H-5
                  \idScrollArea=ScrollAreaGadget(#PB_Any,X,Y,W,H,W-5,H-5)
                  \idCanvas=CanvasGadget(#PB_Any,0,0,0,0,#PB_Canvas_Keyboard)
                  CloseGadgetList()
                  \CallBackSelected=-1
                  \CallBackCheckBox=-1
                  \CallBackDrop=-1
                  \CallBackExpand=-1
                  \CallBackHoverButton=-1
                  \CallBackHoverIcon=-1
                  \CallBackHoverText=-1
                  \imgCheckOn=CatchImage(#PB_Any,?checkboxOn)
                  \imgCheckOf=CatchImage(#PB_Any,?checkboxOf)
                  \imgExpand=CatchImage(#PB_Any,?Expand)
                  \imgCollabse=CatchImage(#PB_Any,?collapse)
                  \IdWindow=GetActiveWindow()
                  \LineOn=#True
                  \LineMode=#full
                  \modeSelectOn=#True
                  \IdHelpWin=OpenWindow(#PB_Any,0,0,100,100,"",#PB_Window_BorderLess|#PB_Window_Invisible)
                  StickyWindow(\IdHelpWin,#True)
                  \HelpOn=#False
            EndWith
            InitParameters()
            BindGadgetEvent(myTree()\idCanvas,@Event())
            ProcedureReturn id
      EndProcedure
      Procedure SetData(idTree,item,type,value)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()
                  \Type=type
                  \Value=value
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure GetDataType(idTree,item)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn -1
            EndIf
            With myTree()\myItems()
                  ProcedureReturn  \Type
            EndWith
      EndProcedure
      Procedure GetDataValue(idTree,item)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn -1
            EndIf
            With myTree()\myItems()
                  ProcedureReturn  \Value
            EndWith
      EndProcedure
      Procedure$ GetTextValue(idTree,item)
            If Not FindMap(idTree):ProcedureReturn "":EndIf  
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn ""
            EndIf
            With myTree()\myItems()
                  ProcedureReturn  \Text$
            EndWith
      EndProcedure
      Procedure GetItemSelected(idTree)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            ForEach myTree()\myItems()
                  With myTree()\myItems()
                        If \Selected
                              ProcedureReturn ListIndex(myTree()\myItems())
                        EndIf
                  EndWith
            Next
            ProcedureReturn -1
      EndProcedure
      Procedure$ GetItemChecked(idTree)
            If Not FindMap(idTree):ProcedureReturn "":EndIf  
            Protected txt$
            ForEach myTree()\myItems()
                  With myTree()\myItems()
                        If \Ckecked
                              If txt$<>""
                                    txt$+Chr(10)
                              EndIf
                              txt$+ListIndex(myTree()\myItems())
                        EndIf
                  EndWith
            Next
            ProcedureReturn txt$
        EndProcedure
      Procedure SetCallBackSelected(idTree,*CallBack)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()
                  \CallBackSelected=*CallBack
            EndWith
      EndProcedure
      Procedure CountItem(idTree)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            ProcedureReturn ListSize(myTree()\myItems())
      EndProcedure
      Procedure SetIconeImage(idTree,IcoEpande,IcoCollapse,IcoCheckOn,IcoCheckOf)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()
                  If IcoEpande<>#PB_Ignore
                        \imgExpand=IcoEpande
                  EndIf
                  If IcoCollapse<>#PB_Ignore
                        \imgCollabse=IcoCollapse
                  EndIf
                  If IcoCheckOn<>#PB_Ignore
                        \imgCheckOn=IcoCheckOn
                  EndIf
                  If IcoCheckOf<>#PB_Ignore
                        \imgCheckOf=IcoCheckOf
                  EndIf
            EndWith
            ProcedureReturn #True
      EndProcedure 
      Procedure SetIconSize(idTree,expandSize,checkboxSize,iconeSize)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()\myParamaters
                  If expandSize<>#PB_Ignore
                        \ExpandSize=expandSize
                  EndIf
                  If checkboxSize<>#PB_Ignore
                        \CheckBoxSize=checkboxSize
                  EndIf
                  If iconeSize<>#PB_Ignore
                        \IconSize=iconeSize
                  EndIf
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure SetGeneralSize(idTree,HeightLine,LeftMargin,UpMargin,marginLineH,ItemOffset)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()\myParamaters
                  If HeightLine<>#PB_Ignore
                        \Height=HeightLine
                  EndIf
                  If LeftMargin<>#PB_Ignore
                        \LeftMargin=LeftMargin
                  EndIf
                  If UpMargin<>#PB_Ignore
                        \UpMargin=UpMargin
                  EndIf
                  If marginLineH<>#PB_Ignore
                        \marginLineH=marginLineH
                  EndIf
                  If ItemOffset<>#PB_Ignore
                        \ItemOffset=ItemOffset
                  EndIf
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure SetColor(idTree,BgColor,FgColor,SelectBgColor,SelectFgColor,LineColor)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()\myParamaters
                  If BgColor<>#PB_Ignore
                        \BgColor=BgColor
                        SetGadgetColor(myTree()\idScrollArea,#PB_Gadget_BackColor,\BgColor)
                  EndIf
                  If FgColor<>#PB_Ignore
                        \FgColor=FgColor
                  EndIf
                  If SelectBgColor<>#PB_Ignore
                        \SelectBgColor=SelectBgColor
                  EndIf
                  If SelectFgColor<>#PB_Ignore
                        \SelectFgColor=SelectFgColor
                  EndIf
                  If LineColor<>#PB_Ignore
                        \LineColor=LineColor
                  EndIf
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure SetFont(idTree,FonId)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            With myTree()\myParamaters
                  \Font=FonId
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure SetCallBackCheckBox(idTree,*CallBack)
            If Not FindMap(idTree):ProcedureReturn #False :EndIf  
            myTree()\CallBackCheckBox=*CallBack
      EndProcedure
      Procedure AddItemButton(idTree,item,icone,size,*callBack,HelpMsg.s="")
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            AddElement(myTree()\myItems()\myButton())
            With myTree()\myItems()\myButton()
                  \image=CatchImage(#PB_Any,icone)
                  \callBack=*callBack
                  \size=size
                  \HelpMsg=HelpMsg
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure Free(idTree)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            UnbindGadgetEvent(myTree()\idCanvas,@Event())
            CloseWindow(myTree()\IdHelpWin)
            DeleteMapElement(myTree())
      EndProcedure
      Procedure GetIdGadget(idTree)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf  
            ProcedureReturn myTree()\idScrollArea
      EndProcedure
      Procedure EventDrop()
            If myTree()\CallBackDrop=-1:ProcedureReturn :EndIf
            Protected pEventDrop.ProtoEventDrop=myTree()\CallBackDrop
            pEventDrop(EventDropFiles())
      EndProcedure
      Procedure AddDropCallBack(idTree,*CallBack)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            EnableGadgetDrop(myTree()\idScrollArea,#PB_Drop_Files,#PB_Drag_Copy)
            myTree()\CallBackDrop=*CallBack
            BindEvent(#PB_Event_GadgetDrop,@EventDrop(),myTree()\IdWindow,myTree()\idScrollArea)
            ProcedureReturn #True
      EndProcedure
      Procedure ClearItem(idTree)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            With myTree()
                  ClearList(\myItems())
            EndWith              
      EndProcedure
      Procedure SetLine(idTree,On.b,Mode.i)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            With myTree()
                  \LineOn=On
                  \LineMode=Mode
            EndWith
      EndProcedure
      Procedure DisableCheckBox(idTree,item,State.b)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()
                  \CheckBoxOn=State  
            EndWith      
        EndProcedure
        Procedure DisableItemSelected(idTree,item,State.b)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()
                  \SelectOn=State  
            EndWith      
        EndProcedure
      Procedure DeselectAllItem(idTree)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            ForEach myTree()\myItems()
                  With myTree()\myItems()
                        \Selected=#False
                  EndWith
            Next
      EndProcedure
      Procedure SelectItem(idTree,item,State.b)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            DeselectAllItem(idTree)
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()
                  \Selected=State
            EndWith
            CallBackSelected()
      EndProcedure
      Procedure SetItemChecked(idTree,item,State.b)
          If Not FindMap(idTree):ProcedureReturn #False:EndIf 
          If SelectElement(myTree()\myItems(),item)=0
              MessageRequester(#Title,"Error this item "+item+" not exist...")
              ProcedureReturn #False
          EndIf
          With myTree()\myItems()
              \Ckecked=State
          EndWith
     EndProcedure
      Procedure ChangeIcoItem(idTree,item,Icone)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()
                  If IsImage(\Icone)
                        FreeImage(\Icone)
                  EndIf
                  \Icone=CatchImage(#PB_Any,Icone)
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure ChangeBtItem(idTree,item,button,icone,size,*callBack)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            If SelectElement(myTree()\myItems()\myButton(),button)=0
                  MessageRequester(#Title,"Error this button "+button+" not exist...")
                  ProcedureReturn #False
            EndIf
            With myTree()\myItems()\myButton()
                  \image=CatchImage(#PB_Any,icone)
                  \callBack=*callBack
                  \size=size
            EndWith
            ProcedureReturn #True
      EndProcedure
      Procedure GetValueParent(idTree,item,Position)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            Protected CurentNivel
            CurentNivel=myTree()\myItems()\Nivels
            While PreviousElement(myTree()\myItems())
;                   If myTree()\myItems()\Nivels>CurentNivel
;                          ProcedureReturn 0
;                   EndIf
                  If myTree()\myItems()\Nivels=Position
                        ProcedureReturn myTree()\myItems()\Value
                  EndIf
            Wend
             ProcedureReturn 0
      EndProcedure
      Procedure GetTypeParent(idTree,item,Position)
            If Not FindMap(idTree):ProcedureReturn #False:EndIf 
            If SelectElement(myTree()\myItems(),item)=0
                  MessageRequester(#Title,"Error this item "+item+" not exist...")
                  ProcedureReturn #False
            EndIf
            Protected CurentNivel
            CurentNivel=myTree()\myItems()\Nivels
            While PreviousElement(myTree()\myItems())
                  If myTree()\myItems()\Nivels>CurentNivel
                         ProcedureReturn 0
                  EndIf
                  If myTree()\myItems()\Nivels=Position
                        ProcedureReturn myTree()\myItems()\Type
                  EndIf
            Wend
             ProcedureReturn 0
       EndProcedure
      Procedure GetPositionToValue(idTree,Value)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             ForEach myTree()\myItems()
                   With myTree()\myItems()
;                          Debug Str(ListIndex(myTree()\myItems()))+"  "+Str(\Value)+"      "+Str(Value)
                         If \Value=Value
                               ProcedureReturn ListIndex(myTree()\myItems())
                         EndIf
                   EndWith
             Next
             ProcedureReturn -1
       EndProcedure
       Procedure GetPositionToText(idTree,Text$)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             ForEach myTree()\myItems()
                   With myTree()\myItems()
                         If \Text$=Text$
                               ProcedureReturn ListIndex(myTree()\myItems())
                         EndIf
                   EndWith
             Next
             ProcedureReturn -1
       EndProcedure
       Procedure ExpandAll(idTree)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             ForEach myTree()\myItems()
                   With myTree()\myItems()
                         If FindMapElement(myExpand(),Str(ListIndex(myTree()\myItems())))=0
                               AddMapElement(myExpand(),Str(ListIndex(myTree()\myItems())))
                               myExpand()=#True
                         Else
                               myExpand()=#True
                         EndIf
                         \Expanded=#True
                   EndWith
             Next
       EndProcedure
       Procedure SetCallbackExpand(idTree,*ProcedureCallback)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             With myTree()
                   \CallBackExpand=*ProcedureCallback
             EndWith
       EndProcedure
       Procedure SetExpand(idTree,item,State.b)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             If SelectElement(myTree()\myItems(),item)
                   With myTree()\myItems()
                         \Expanded=State
                   EndWith
             EndIf
       EndProcedure
       Procedure SetCallbackHoverText(idTree,*ProcedureCallback)
              If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             With myTree()
                   \CallBackHoverText=*ProcedureCallback
             EndWith
       EndProcedure
       Procedure SetCallbackHoverIcon(idTree,*ProcedureCallback)
              If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             With myTree()
                   \CallBackHoverIcon=*ProcedureCallback
             EndWith
       EndProcedure
       Procedure SetCallbackHoverButton(idTree,*ProcedureCallback)
              If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             With myTree()
                   \CallBackHoverButton=*ProcedureCallback
             EndWith
         EndProcedure
         Procedure DisableModeSelect(idTree)
             If Not FindMap(idTree):ProcedureReturn #False:EndIf 
             With myTree()
                 \modeSelectOn=#False
             EndWith
         EndProcedure
       ;}
      DataSection
            checkboxOf:
            ; size : 4283 bytes
            Data.q $0A1A0A0D474E5089,$524448490D000000,$2C0100002C010000,$4674D30000000408,$474B6202000000FE
            Data.q $00BFCC8F87FF0044,$0073594870090000,$01BF0F0000BF0F00,$09000000A732B09F,$2C01000067417076
            Data.q $7238FB002C010000,$414449C30F000069,$546C6DDDEDDA7854,$6076C7AFF1C79DD7,$C18218B0C49800FC
            Data.q $C90C4B4B8B80E038,$B66D02FB68B4BBD6,$46945DA2C44B222C,$96ABBB421110522D,$B0B55B378514BBED
            Data.q $BA5554B2E9BA8A51,$49805F62FA551144,$12989D820502148B,$D8E0CCF32C05EC1E,$12C985F661F831E3
            Data.q $1E3B9FF39C3CF602,$9CF73C8948573EFF,$DEE73BDEE9F9CF7B,$94A22985608F2773,$8932A64CC9525469
            Data.q $F018530BFDEE8A62,$B9E944623EBB65D6,$2E05C8B95736EFF7,$69B905887A2E9970,$7C15294F9AD48179
            Data.q $12941524F354F985,$FA23910D90414C26,$8E712E0E8BA31189,$7E640C5D074C7C53,$62A8CA7CAC1B3243
            Data.q $33E3194D51D47521,$D1CE112F4A63C3BF,$C064C912B4CD1344,$37CC59CA02AC1532,$C32E29D44C398E79
            Data.q $6390701F3CE4E8FA,$AB07DA55133FA75C,$0E632C5BE19E7280,$E737561925D89925,$DB2F1F68FE469F79
            Data.q $354E59E798B09560,$8E72882921BBB6C5,$B12AEDBA31C7BC03,$0D0D672CE51E560A,$2712464105F40594
            Data.q $B713AE01C37E21C2,$79E2A9F3D3A2C0A8,$6E23CDC6C255F356,$FFD5A3DE1DE49C62,$3ACB988560EFBD65
            Data.q $3F44A307834AA05E,$67D0619C57E5ECAD,$C4BCB58335837EB1,$906AE234DA328453,$A457F769AFC5BCB3
            Data.q $9167DF25664D60BF,$E7E23E3EA9461286,$2B04FCE29F96E3EC,$1AA6BA17F23672CC,$71F01C9D81FC62E5
            Data.q $2F33629EB047C833,$DE111788AB741652,$71DF262D759C27E6,$75AFE53F2DFCF1FD,$2DC0D3166119CAAC
            Data.q $9B3582DD5086DD5A,$A72AA4696623F11F,$DCA7CE536F8D31E4,$0AC85583F490BF4E,$E349CE48DD2AC67E
            Data.q $20EE96D0AE59E7A9,$CEBCABC09AC1BA44,$F8331E5672AB1D5C,$A7AB3A4EE668F22B,$0C4CABCC7E0AAC17
            Data.q $2A60DF3158C5DF7A,$B58274D57D4AE827,$131AAF1A77F19F90,$AA6AE63E02C4580A,$4ECDBE3CAC1AA62B
            Data.q $8A78F2331C0A741A,$05A96ADA9AD1B4A5,$7A0BCCA7E7BF80AB,$9C1B8CB1A6C3255F,$F21560953E42E54A
            Data.q $0094BDE82D33B65D,$AD1F2734DB81A44C,$4F31F977C05583E4,$259E22901287BD04,$4358364AD1B25342
            Data.q $A50093BDE83C7AB1,$6C4BC05582E4AD14,$56E59E22BCC6AC53,$81FE2158264AD172,$8D75A286141275D7
            Data.q $BFAC1327338FC4E6,$96491EF41A98DFE1,$63E89A7CB39EA228,$F41D993B0CF58389,$74A38EA5291648DE
            Data.q $0764AAC144A1FC8C,$E672996489EF41F5,$C1C8C8FA473A7BF0,$3CBB28D4ACEBC49A,$3FE1DE9EFC651664
            Data.q $6D655E429A5CD230,$59978820601AB160,$99AA3F3BE4F92A8C,$6FA36CBFF2D63C9E,$7264DE05EF0C0FF8
            Data.q $D06E512880743686,$F16F7621E8D73B4E,$5BDF0884C729253A,$C504F0660CC2988A,$DEC0D8B76A2C6714
            Data.q $9B786AB07C38FEE1,$691736E7EB8DF33A,$2C4621102E1699A6,$09840531C8AD2F33,$6642C8580B254653
            Data.q $91789B3B33032932,$A6E22EC452ADA9D3,$29EA46CBBCED1F4B,$463D3723BA80B1E7,$33E9DA5DE46CF539
            Data.q $EB71B6A5145DC5EE,$8FB3AE4198DB32E8,$452524A3754DA857,$59A0CEB8FB0AF2D4,$A1AA4D952EB1765F
            Data.q $0D076569FA4368C9,$0EC0D314C64CFB7A,$926A26D1EA37E95A,$53907069D1B094DD,$42B8CD3D9EBE656C
            Data.q $5DAE47465395B3E6,$F541A7455BFE4EC9,$2605898D3CCED897,$76CF4192E76C798F,$F7A0E7280D992AB2
            Data.q $81548EBD4DD8BBAA,$07CF5706DD9EA42B,$AE7AF4CBF95C4F29,$C51ACAA6BAF585B6,$72F2F70F73C5A7AC
            Data.q $28CAB5EC382B6AA2,$51E4AB3009D5A87B,$1530F9FB5EA21ECB,$BBAB1EBB89BA5723,$8479476E834A66C6
            Data.q $65DF4F63CD733652,$CAC784E2CDD548D3,$055ACBF5EF4AB34E,$ACC13EDEC7B4E2AC,$10E3B471E2DB2BE1
            Data.q $872960493B6E834B,$66AB865B3F77F5BC,$83A79FB355BD471A,$D6F7ECD3C249356E,$9896B81A9B8747E7
            Data.q $AB012B1A3D2558B7,$41551F6B18AD16F1,$8D58A8D0553D7B11,$8FBDF9EA7A34352A,$6F0A5E2B84BBFBBA
            Data.q $E45A29252DD05162,$E8B97C9615F0DEE9,$822B3B7452F35E3C,$F4BDDA0AC349256E,$65EE9CB31E5F6BFF
            Data.q $A8FBC77A0D8BA1A0,$98273D5B97836214,$0EC48C3DABC160FE,$ECC2B51DB92F53B2,$2C5FD59443F4F0F4
            Data.q $D538F5A43C379F34,$87B8E6A8388EB741,$78A7EE67C5F1BC14,$388CB7413593B228,$B94CE3A981E1E35A
            Data.q $42FE05CE2232E05F,$E70BF3C6F51E4FEF,$5ED4BBDC0658441C,$48D7676A4DC724C2,$F39765E8546517D3
            Data.q $0108721A1A4D350F,$A089C3BDEAEE1EC5,$65CE3BC1383C455B,$1CDA6ABBE9FCFD2C,$9928819819AD7F0F
            Data.q $1EA8DA1A63AB4751,$2D2B72F17ED5623A,$F93C43DBA093E3BF,$A1DA85309639DF84,$9F6117DF9C702D60
            Data.q $C447D8063390B2DE,$CE718840162284A9,$886B741638474FA3,$E3354258E238C747,$BF3F4854E5509442
            Data.q $8CFA3C42DBA0B3E5,$10928AA33FBE3ADF,$050E55C854E93C65,$E27FD4A1D9E212DD,$13366216524F01E4
            Data.q $83B7418B84F90A9C,$6604D8CBF1D17678,$A61F2153894B9887,$D0F8BAD59250DBF3,$38CD9886E612FD69
            Data.q $882B741E39BA2287,$D98E3DAC3B74E381,$4CE2E8130D1344A1,$879E38CE06206DD0,$66E0EC832F8E422A
            Data.q $DD7A266E06206DD0,$AD58578E43930276,$F54D1031036E8344,$175835C4A4BF09F7,$05C6206206DD0588
            Data.q $B6B4E9D5839DF5A7,$4E960E759EB72F64,$60C76D69C7AAB984,$F4EA2BD92F56380D,$BF4D5E69C8494160
            Data.q $30BF74EA2B39588E,$A09DC838079A721C,$9055FA71DC8C5FF7,$28883F84D2F4EB90,$98B2DE6ACF6394A3
            Data.q $1426258284C4B050,$4B05098960A1312C,$1312C1426258284C,$8284C4B05098960A,$8960A1312C142625
            Data.q $426258284C4B0509,$B05098960A1312C1,$312C1426258284C4,$284C4B05098960A1,$960A1312C1426258
            Data.q $26258284C4B05098,$05098960A1312C14,$12C1426258284C4B,$84C4B05098960A13,$60A1312C14262582
            Data.q $6258284C4B050989,$5098960A1312C142,$2C1426258284C4B0,$4C4B05098960A131,$0A1312C142625828
            Data.q $258284C4B0509896,$098960A1312C1426,$C1426258284C4B05,$C4B05098960A1312,$A1312C1426258284
            Data.q $58284C4B05098960,$98960A1312C14262,$1426258284C4B050,$4B05098960A1312C,$1312C1426258284C
            Data.q $8284C4B05098960A,$8960A1312C142625,$426258284C4B0509,$B05098960A1312C1,$312C1426258284C4
            Data.q $284C4B05098960A1,$960A1312C1426258,$26258284C4B05098,$05098960A1312C14,$12C1426258284C4B
            Data.q $84C4B05098960A13,$60A1312C14262582,$6258284C4B050989,$5098960A1312C142,$2C1426258284C4B0
            Data.q $4C4B05098960A131,$0A1312C142625828,$258284C4B0509896,$098960A1312C1426,$C1426258284C4B05
            Data.q $C4B05098960A1312,$A1312C1426258284,$58284C4B05098960,$98960A1312C14262,$1426258284C4B050
            Data.q $4B05098960A1312C,$1312C1426258284C,$8284C4B05098960A,$8960A1312C142625,$426258284C4B0509
            Data.q $B05098960A1312C1,$312C1426258284C4,$284C4B05098960A1,$EF41795835C26258,$4E8310D9EC711880
            Data.q $38C8C5FF7A0B8F6B,$EAC3988860CE83A7,$98A462FFBD071405,$561DBA2163B58702,$C52317FDE828A7CF
            Data.q $742C16EDDDAC3BE4,$60E70C876E59CAC4,$CF5B88C5FF7A0C4D,$202DD07092AB073A,$AC1CEFAD3A54C206
            Data.q $4E553152730C9D2A,$054054E5B88777EB,$2A71E06206DD078F,$80A9C3A215BFD69C,$2E606206DD06E652
            Data.q $8EE3688477EB4EA5,$1036E83D7C250143,$B43BED61C4A75F03,$31D4B59578E33885,$7EB4EA594A7D92DB
            Data.q $215399F1B4426737,$99B3C41DBA0CCCB5,$22216D19FFAD3AD4,$B7410D2A642A725C,$2FF5A754C0D67883
            Data.q $052153AB4DD10911,$347884B74109877C,$BA568427DD38EF81,$612C86E39CE1DC43,$89662D1E216DD071
            Data.q $E85A0213B8E70963,$2C374E958CA62A71,$12A73292B3E49B25,$88DA6A8FFA19687A,$E21EDD05D4AD2D3B
            Data.q $7AA368698EAD1D49,$98DC749CCBD209E8,$28764B2B3C77ACD9,$E5C938CB1DB33D60,$568379D0F94560A1
            Data.q $1AF83C44DBA0B5F3,$CFE7E890F8CB9DAB,$F8336163B6E11FBC,$9E3471156E83E31E,$B91CDB8CB1C331EF
            Data.q $8D5E78EE38533FFF,$AD1C45DBA09AC9D3,$BF7299C70739D3A1,$71CE302E70DE7CC0,$E1ED5071196E83AA
            Data.q $560847078DE712F0,$EC7A9D90722E7513,$0CE74193B30AD46F,$1E139D368D7CBF44,$951D814D06C5DAD2
            Data.q $304E0243CBA06C42,$B143CD78F382C1FD,$1A491B741159DA71,$787B5FFFA5EED056,$89BA2978AE12EBA2
            Data.q $4D1168A492B74145,$15066EA3CAFEFA5E,$09A91A71E14BD7B1,$EA7A34350524A5BA,$9896B6349E8FBDF9
            Data.q $0D46A35A2BF60AA7,$AE8FB58C7AF53DFB,$3F6711553D471A62,$BDA7849262DD074F,$CD570DA651CE2AC5
            Data.q $F1F1C87355BDFA16,$BBFADE4394B7B156,$A0CBCB3457C32D9F,$74D6E95669CBE7C3,$F6F63DA715602AD6
            Data.q $7AEE26DD548D6609,$2B22D5359B1AECAC,$2EFA7B1E6B99B295,$AB1EC382B0AE469B,$5B3D7AB50F65138B
            Data.q $B4EE1E3D96A3C956,$CBEB82789C39717C,$35EB0B4E32AD7AF4,$CF169EB3146B3F11,$E72E2B89CBCBDC3D
            Data.q $7A9BB174E36AE7A0,$7A90AF31D36E830A,$9072E0F375B97B76,$89E1E1E55FAA64F2,$8A4E9E676C4B9787
            Data.q $D064B9DB1E63C981,$ECC2136E4AAC9DB3,$CAD8A720CE3EA832,$6CF990AE32B91D7C,$ECB51E17A78794E5
            Data.q $8EF74F1A9699FE4A,$BA0D076569FA5E1E,$AB41D81A6298CAE6,$EED4A69707CA11C7,$723FDF133833ACB2
            Data.q $9837AB50AF1F675D,$75C7D85796A22A9A,$4BAC5D389C5523A3,$3E97F7874E6CA375,$63CE53D48D9779DA
            Data.q $EA728C794E41F741,$8BDC67D3B4BBC8D9,$5D317F0C383B86BB,$6DCFD82D9819DBC3,$42205C2D334CD22E
            Data.q $5628C8F541FD188C,$8580B25465309840,$A3D770329326642C,$F48D3FE8FD391789,$1A867264DE05ED2D
            Data.q $3B4ED06E51288066,$79F9716F7621E8D7,$62296F7C22175C83,$BE3B1413C198330A,$E1DEC0D8B7153B46
            Data.q $3F21F90AB05238FE,$010300C03534EC0C,$CBD81F93E45A3DD5,$F70DF46D8DB2EE0D,$FE13F12695C791E7
            Data.q $D9BB3890F24F6351,$CBDEF391D46CD23C,$39EE4B5CA79CEA49,$074481F48EAE66C8,$B01B9237C4FE4ED2
            Data.q $C8D4E46C4FE33197,$BF9DA0EE867C491F,$99B32EFFF22FC3D4,$2CEFD2E64A1F44C6,$37000A660D73F937
            Data.q $92C7D13C4DFF01F8,$A29CF0884F9C5609,$B6F993BB2B64DC25,$F0889A41D597DC9E,$6F2B64DDC635A2AC
            Data.q $A28828EC9D803725,$5F7B247FCAD93725,$B0899A41B5E1F924,$C9AFF06EA31AD154,$B51D0D609520AD1E
            Data.q $2E831C28DFAC583A,$5371772A57FC2FF1,$3B50B4C7C83021BB,$89B11F49C944C4FC,$D34EFD4DB7DDA97D
            Data.q $33D1BA398B330E79,$5483E46C3FF20C46,$320E55E616E74B57,$F2F4063A8C9A0581,$DDE91313F3A4B64B
            Data.q $07A750F40FE2EF1B,$371B675E75DC738C,$70EE2E87DD3559D2,$1CC4A75D30E61684,$BD2C43D85B28E715
            Data.q $1C3390679A7FD3D5,$3A839DC35E8D4420,$2D07FD34713FC5D9,$4A7CFBCDBB131EDD,$73890E56E3A67F35
            Data.q $7E053BD3DFE67F92,$48D14E7EC3F9F5CE,$F0888E725F7AD521,$1F03CCEB90E16C9F,$671E2691A2DEB60F
            Data.q $F91A31728EA2A6BA,$FC725F08FC8E6F01,$48B3EF92B326C29D,$B39F88F8FAA51AE1,$346D7BF38A7E5B8F
            Data.q $FBD77A53C4BCB583,$B4D7E2DE59C83328,$B9887745F7D22BFB,$4A3A7C34AA05E3AC,$BF19C57E5ECAD3F4
            Data.q $C553E5CDBE2CED53,$72CFA0BAABE6ACF3,$7FEAD1EF0EF24E31,$2CE51E4130D59DA2,$0B222869940D0D67
            Data.q $EB8070DF887089C5,$97A76D874E331F89,$FE6EB54E59E798B0,$1C7BC038E7289164,$0149A3FB12AEDBA3
            Data.q $4A1CC658B7C33CE5,$F79E737491936BCC,$46437EB75C8FE469,$6F98B39405534EA6,$0C8921A898731CF2
            Data.q $8E41C07CF393A3EB,$F27FAF66486A47D9,$354751D4858AA329,$E70897AC68CBBA65,$F264895A6689A268
            Data.q $4A53E7585CC1185D,$05493CD53E615F05,$7E83C2806B0984A5,$E39C4B83A2E8C462,$572F105741D31F14
            Data.q $994A22985B1BFA09,$28932A64CC952546,$09994EB0BFDEE8A6,$B77FBDCF4A2311F4,$74CB81702E45CAB9
            Data.q $1FFC7E2F03EE93D1,$91097CF32F6E0EDA,$7458457425000000,$6572633A65746164,$3131303200657461
            Data.q $325431312D31302D,$2D36333A31323A30,$D665C930303A3530,$5845742500000021,$6F6D3A6574616474
            Data.q $3130320079666964,$5431312D31302D31,$36333A31323A3032,$38B830303A35302D,$4574190000009D6E
            Data.q $617774666F537458,$692E777777006572,$2E65706163736B6E,$001A3CEE9B67726F,$AE444E4549000000
            Data.b $42,$60,$82
      EndDataSection
      DataSection
            checkboxOn:
            ; size : 80288 bytes
            Data.q $0A1A0A0D474E5089,$524448490D000000,$1A03000020030000,$22917E0000000608,$41444900200000A3
            Data.q $1D9879DDEC9C7854,$EAB739EFF03F9955,$21084909D3BBA776,$191110182FB21086,$46092D9119361875
            Data.q $7470DC1D46DC571D,$8CA7E4571D477704,$8638CE8A3383A8E3,$108622C885446DD5,$9086B0B210921242
            Data.q $BF39EEAABBA74F7D,$776FB753AA9D4E3F,$F3F7F76FAB7DB97A,$293DEE49A774FD3C,$05F7DE7BCBFA79F4
            Data.q $8888888888888888,$2D37A4F288888888,$AF9AA53C586F433A,$4444444462F9AB29,$6AADC596F4FF5444
            Data.q $7DA23E52D67F95F3,$A88372F57CFEA775,$3C002D510D110BD6,$D11113EF8562EBE7,$B07D7F14401877D0
            Data.q $88068889CB956BEC,$63FF16951BE572DE,$98B8F8B420042D7F,$10067D78D59BE4BE,$3260049800C62E1A
            Data.q $7F1B180346000980,$26EBF38C79FC747F,$0E58E888888361A4,$EFD8FE37B0036802,$63F8D9FAF9CFBD7C
            Data.q $2DE828344310D21B,$38B4A7BF2D6A670B,$2798B525C3C1301F,$0061F7DFDF592C66,$A600E9800262A1A1
            Data.q $31C09864E0029802,$2223075E5375FE29,$69E00ED80140AA22,$093C00678FE35B00,$46CE9CF6FDFC7360
            Data.q $5F1AA371707E8CC3,$5140827F892A94FA,$E20042210DC3C938,$0AFD4FEF38BEDDD9,$C005A4F54242BCCF
            Data.q $133003CC0173006C,$7AA22220C060E869,$15B2BA3F8C4C0122,$F58038F0046C9026,$D0AAA21384C03600
            Data.q $446E95186D7CAE5B,$0D6B42754C054C49,$80D688434EB4421B,$9FD4BE00B5DC6938,$8022A306840564F7
            Data.q $36638130398FE3D3,$AEE1A2222229F5CC,$FE2EB007AC88260D,$E88F51175AE602BC,$A56DF7948A4C57CD
            Data.q $2B9F30E95CE808B0,$6F73144EA0644257,$BCA10066F7D7DEDB,$C597801671709849,$44444417FD83E79F
            Data.q $C70F0072C00DB5BD,$F42510A2F4C0579F,$850F98D2753D73D2,$1B7DFB168100BE01,$9EFDBEFD91F0D236
            Data.q $7F7165BB4E45B810,$E008D6B54200C0CE,$19C007380017006C,$AA2222227E3FFA40,$F7006EE461308DAA
            Data.q $2CB7A530D3C034C0,$3EB495EFA810557E,$2B1C1034884F7ED5,$E4B698B0F8A41484,$340D0803073DFD3B
            Data.q $1D0987CE0099C00F,$54444444210980AF,$76481B1104C24F7B,$92E6BD05AA1C7BE6,$BD508237C34361D1
            Data.q $D7CE19AA6FF8FEDB,$7C9E78842AEDEFF1,$0F38D547E4BA9897,$042E00D9840D0803,$220E1583954C3170
            Data.q $023F803D69C1A222,$684BFA609FC00BB8,$877B5D7A2D368908,$A30130013D2951BE,$47BF38843CA38552
            Data.q $D3FADEA62EDE1E79,$05A1AA8401899D6A,$8CC0D7803171C2A6,$0ED2FAA2222225BD,$3077E007FF003EE0
            Data.q $278B13F4A754EE8D,$16941A3DDF4A9476,$20D9D7F103D54C88,$9BC05F9100843152,$31B3CD517F5B8CC5
            Data.q $802970044D5F5080,$111155AF05CE0085,$C003B8024F350D11,$01D7BE37098260AF,$8E077DF2BC6D400D
            Data.q $A3A1380AD0035F44,$504404421774882C,$AA3BD6FD3106F1F4,$00F98DEA1006467D,$11075F4C0570072E
            Data.q $16FC017B0F0D1111,$1EF9C391D5309DC0,$1C3CCF161BD12A87,$DE539D28EF6C3F46,$884315101A099E40
            Data.q $1450DED0290BE694,$CE2076FEB7698A57,$B7802A72C74200C9,$88888AB5783D7802,$0CFC01EFC0008088
            Data.q $2BD339ED8DC242A6,$C0E9FE532D05EA5E,$4F2A04688033E0A1,$844210AAC15CCAB2,$42BC83635B40A400
            Data.q $065E75038FF5BB4C,$04C137802264AA10,$888888859F39F98F,$3370036E00C3AF06,$E0B1AAD35E2D54CC
            Data.q $D4DD2B691E674589,$B2C142F940F9A811,$12910052BAFCE1D0,$6F53162E16344787,$564200CCCF206079
            Data.q $985CE3A13045802B,$B53D444444448105,$9CAAC8C261CFC00D,$753517D5E9E432CF,$90FA3077DE5FCDF8
            Data.q $579FF8AB55C99686,$0710591004DD1D0C,$964B198ADFC2FC9B,$0074E84019D9F40D,$112E5C7078A987EF
            Data.q $83DF000AC3551111,$A6E1655BED1C2409,$83F7C740FFB45DD7,$40F954EBDFB14F50,$6F629480948842CF
            Data.q $CAC97D316AF7A373,$846A7864019F9C5A,$9F3959C01AB8E9E9,$00FDAE8688888885,$9FB7D6384613027E
            Data.q $86F0E88E63C5BAF4,$9DE7FA55B7A307FD,$200B28E842A15BAE,$5ABDE0D2DDD88285,$C80315AAB3525CCC
            Data.q $801571DAA61D32F0,$86888888851EF931,$4400DB9104C13F99,$BCAE9B44FEA51EF9,$26A84187E0DEF774
            Data.q $BE325789F2B3FF94,$4E8A5258099D2F48,$DE8D2DEDC82BC401,$5BF9B5F592C66205,$2E6E519BE5ACE7C4
            Data.q $EDEC81259861F002,$F0036D3CA2222220,$B3E73BB0003F005D,$888FA325CD7A7A0C,$A1A6DE0FECF7B7E2
            Data.q $BB8AF8C7E70BEF93,$FC401E520AB6443C,$B313CEF452D6DC82,$6401895FF1AC6C97,$00D70016F0026B08
            Data.q $8888888859F39D98,$06DF006FF803B5CA,$C6D14A0CB3E726B0,$6187E3A7B1DDAF45,$9E9967FD9D6A27A4
            Data.q $200EBB21E5D8540F,$13CF20D91D9F2FBE,$2C937F36B27D6F33,$020F803C67A19006,$111111159AF007F8
            Data.q $79FC5AF8023F87D5,$123A1EB7165BD3D8,$7EEEAAE0BEF77B7E,$F1004C887AF6CF5F,$7313CF27AB64F97D
            Data.q $E7CA957F06B67B6F,$F802A6EAA98DEBCE,$2227326984EF0047,$057C00AB37AA2222,$CDC2453BA6182DC0
            Data.q $105370677DB35F0B,$DDC3E555D00089A8,$0F3EE7443F549E70,$B1B5B1B17D148037,$FECD5B64B5989E78
            Data.q $01D3BFD480301542,$883BFB15AA66027C,$37C0127828688888,$BD75A6C98617FC00,$EC370DED43D6E2E9
            Data.q $CE51D0F2CEF1DDDC,$B6E74DB6BFB874AD,$28B1AB057A6521DA,$25BCC40BC5FAB7D7,$200C4C72AFF807DB
            Data.q $3069805F006CEBF5,$02768A1A22222227,$89F7843077C001B8,$6D1DF6D1775E9B84,$47D38E927A07B537
            Data.q $88421DAA951F2B4F,$AE41A1A00A4407A4,$3258CC4F3C54D51D,$7CCFEA4019FE9A28,$2107DE6970065F00
            Data.q $3F30ED91AA222222,$AA59F3904000FCFF,$86D1D0F5B8BA6F46,$BE2AF7FEDDD8EC6F,$7036220D87736670
            Data.q $034008347AF74800,$A1A04291007DD4B2,$58305E296E8CD728,$02664F5200C007C2,$88AD5781D78022F8
            Data.q $E7C0167A78688888,$DC244BBE7514FC00,$E9BD1E76DB85E578,$5A1DCACBAC9ABB68,$D1880A42595CA767
            Data.q $72BA4CE6D0050C80,$50D1180AED3A4802,$07A9006003E17418,$5E0036F68FFE6193,$0C1A2222222167CE
            Data.q $0FBC8BF47CFCC036,$FD074D65C57A5BD2,$9B3EFA3AEC2FF5C2,$9A4ACAE57CEEB43B,$07D880BC71001BCC
            Data.q $053A64ACD765A388,$9ADE0D11EBF34A4B,$03001F0BA0FE2DD1,$1F003AE002D660C8,$55111111115AA705
            Data.q $0FBCB2F2D9661CB2,$B1DACE0B13C113D2,$1B4CD2D1F0F9B82B,$F3DB87C315D6B43A,$003B0038E202C621
            Data.q $5DA76643CFA156D9,$18696B8E6B94688D,$DEAC19006003E194,$083EF313007AE008,$982FF81D51111111
            Data.q $F44AA784FB9B70FF,$F27DC7F1B6BD73D2,$CAF095A33E476D99,$0355EAE675FB8743,$02772028A2002620
            Data.q $B2B75EE566BD9238,$D66B8E6B946A6FDF,$03E1941ABF598817,$5DF0074E6C190060,$44444420FBC8AF00
            Data.q $EFD084CC30E67544,$A78BCDEBAA351060,$83FB7DE6F47DDB6F,$91A1D4D2AE57B3B3,$803C7101085CA1FD
            Data.q $A8F202EDF3C6E2E3,$92BF5EC401E567F9,$A4D71D56F26E6812,$3200C007C3983D5E,$B04EF3BA59838C58
            Data.q $363FA88888889CC1,$6907DE6DFACB5CC3,$E1EB6A7FBFCAFC7F,$E2ADD7253748A21B,$EAB8C6ABB5E5D67F
            Data.q $44005E20342028D1,$06CAED726EAC765B,$D31AADE4DCD02111,$379200C007C3F83C,$746006BE00DDE009
            Data.q $4A1A2222222167CE,$F5AE9E0083E00D7E,$1FDAEFC70BCDEB1B,$035AA5C75763B4DD,$1887CF5DD572B9CA
            Data.q $4C2D2A95F1B1802F,$A85428F7ED9238F8,$1800F84FD734B47E,$3803EF800674F240,$0D1111111083EF33
            Data.q $1A89BE0C6B30ED51,$53E9795D368ACB5D,$5E34BDADA9B91ECF,$468F9EA779A372A3,$4ACD3C6344022F00
            Data.q $D2B647C3889B7203,$7F66C8DEFD878361,$F6E73102F21198D5,$48030355FBF8B5BD,$F03EF3A459868DED
            Data.q $6C2D5111111115BA,$1BD40CF7007EF004,$371D05F65B8B75E8,$A50035BBE8EDB73C,$C625C3E7B647AADC
            Data.q $212034441C7C600B,$474AB291E4079E20,$18F9EE3AFCCAFD7C,$F0ABA85CD71AADE1,$269802DAD4803001
            Data.q $AA22222222B74E73,$7F554006B8009FBD,$E7B9FB3A2D360F60,$56DD3470F07CDE8F,$1147F29D1F2BCA3B
            Data.q $003D571CD1019310,$63B38710179E4013,$D2D1FAB75D98ED75,$95A9006003E19F54,$444E62D9846E0009
            Data.q $6AE009D9F9444444,$73D2F485F7F4B700,$6796DCFE8FC7C3BD,$A1E0F2BC14AB5F0E,$C6AED733CEDB6035
            Data.q $9ED8782612B95CC2,$76BDD21F2A673C0F,$EB9B23D7CE1E2B65,$1570B5200C007C37,$2222227326C01B80
            Data.q $ADB220980EE4C1A2,$773385F1FDB87F2F,$99C17DEED9F8E9EE,$B8A8E86CAE57A75A,$E2A310193003DCDD
            Data.q $73E400200E3ABAF1,$851FAB2E8A43E571,$8170D4DF1C7CA982,$00C007C32EA4B798,$0B8021F800A69032
            Data.q $5511111111073E73,$6F51F8023FC01FB6,$FCDAAF0B0DD1D0FE,$E0D8B750831BE1D4,$A40165015EAECAA1
            Data.q $2B95E9F800531015,$943C8073D5DA7881,$C91050AAE93B0E86,$CADE2D9181292BE4,$07C39EBABE3447E3
            Data.q $DBE009DE503200C0,$111111083EF25A00,$C703BC00EFD31D11,$6BBADC5D37AEA4D8,$637B685EE7FDFFBF
            Data.q $21AD687CADC3C157,$DA8F1718032600A4,$741E405679005945,$EBF885E68D651E2A,$200C007C234391D6
            Data.q $0F5EC1EAA61A36D5,$2613B2FAA2222222,$745A6C18605C5484,$87839FF91CCF53F6,$B2BD5CC8F06E29A3
            Data.q $054C019A87FB0F95,$E2341C40A5F98344,$FDB3FB90139F2200,$351ABD5EC3F56E1E,$CC40BA837C795BD2
            Data.q $C135067E01FECDFF,$C0C7800E73D5B031,$C68F5444444441F0,$FB46A0E0CC0DF803,$B82D8F83C879FD4D
            Data.q $28703FEE07E3CD76,$E4A349511A52529A,$D287CC34A1F3287E,$011BA00E7A0227D0,$02B62035FC9FFE5D
            Data.q $D7663B01D11A6BD8,$2968F95C49026D7C,$0D5202B001F0A90C,$740C16B8002F801E,$007AC14344444444
            Data.q $8F75BBDF2E1BD06F,$2B77CF479D85F9BA,$D16150ADD7C54A1E,$EBD25A00E9802360,$3E4AF57A75200056
            Data.q $E7D372E698F7202F,$6A8D5EAF72B55E91,$F85487A11F8E56F1,$005377D4CF0FCC00,$1111111399B7012C
            Data.q $23E260BB2F73250D,$945A149412386C8F,$F73A3E7B48F049D6,$705100530004E07B,$880008424EBF1BFF
            Data.q $7F1BC11E3BB101E7,$D2609961AF6D7CDB,$5ABFEADF19ADECDA,$01800F85487DB9CC,$C600BFF0042E3FA4
            Data.q $AA22222222107DE4,$8799AFE7C4A2C68E,$62E92C317C7E5EF3,$5530787CA923C177,$C4B0E86CC2A7E48F
            Data.q $769D121012EC4036,$C5B230210B5FD87C,$19881711D8C27F5B,$DF4803095E70DFF5,$222B95E0CBE00B5C
            Data.q $91B4F66321A22222,$06D8FC71F3B5C6F8,$8EBED3A56EBD9494,$B305981A518F954A,$034200687B36DCD9
            Data.q $80EC404DB12BB4CE,$1106C803C1301F09,$E389E36F26968021,$7FB5DD92EA6279E5,$002D3BD200C1B502
            Data.q $222107DE51600C7E,$A6EBC779EAA22222,$44085205386F5DE0,$CA1C4994A1E0E751,$5DA424C00531F1DD
            Data.q $B636F9C421A742D5,$ACD7B2CD5CC17801,$FD9A5AF7E9BBB1D2,$75313CE23B1A2FCD,$00C273A5FC9ACEC9
            Data.q $267F1EDC01B373D2,$48F46021A2222222,$359D4E3E6EB8DF1F,$AF8EB4AD53A54A0A,$01BCDDBB87CAD95E
            Data.q $BF29D7D323005CC0,$C404178960AF6570,$F7EDC3A1C42C80F3,$E8D4D020A1478388,$7D313CE17C693D3D
            Data.q $900613D7B3369F49,$F35A00CDC01CB99E,$C75511111111083E,$B991FCFF16319D5F,$366DC3D54DF26E68
            Data.q $0F1C7CAE3068B4EF,$1DEBCBA29F922660,$DB5DB8CDDB11106E,$290FFE991DAB6E64,$A6F8F93AD850D4D0
            Data.q $37F36B5B25F4C4F3,$661A7DB1C80317CF,$888888883DFB2ECC,$819CEF23E0010086,$A451035A093C5DD7
            Data.q $A6C56EBC788F1ECC,$A22FC4263C130173,$FD3010FD54EB17D3,$CF1ACAAD933ACF1E,$F275B946A6DDD8ED
            Data.q $D74F25F4C4F3E6C4,$35AE90063B9FAFE8,$111120B1707BF4C1,$D71174763110D111,$A502D298CC34EA7F
            Data.q $A6DD7663CE8F0710,$874FCC1E7A00B473,$70D247A2CA3E5A70,$93CE1A6D3C4043BE,$680210F84C887306
            Data.q $05F37C793F6C2C6A,$F9027BB5CD92FA62,$015F80326CA90063,$8888888841F79F98,$F17C18FA7E5E3AA8
            Data.q $A52A21E11A68799A,$D6878315D254A3A1,$D64EBB119B493A80,$015DB8CED0F47190,$8053C402EC4B0533
            Data.q $4142AB74EDCC1B88,$88C464254C3E3BC4,$66205C471389EEC2,$0313C8B3C798D92C,$02D20DF800676748
            Data.q $0131D5111111111B,$3D2F1BC34DB7EAE0,$9B9B34C951014A09,$A134DAE6CD655749,$2BF5CD631EAB8FC3
            Data.q $310849D053D7D3A1,$CC5B101BB57F1FAF,$0F15B2BD5CE90F9E,$9D277B906C69015B,$D7D75B8CC34174D0
            Data.q $9759200C0A0C51F8,$4420FBCA6C172CC2,$FA47A37FD4444444,$23A9ACC34F27E6F8,$B95FAF88F04E5251
            Data.q $BC00E38FBE92AED3,$96D788EA4E0DD018,$20377CE1B32441BB,$620AA7495DAF6537,$4F93C1E516355EAF
            Data.q $6A6BADC671757A6A,$3FD490061D0608F4,$222227366C11B800,$F871EA7A5E121A22,$510F08F343CE3FD2
            Data.q $92AED3B95BAE6549,$E253D0D74F4001E0,$B9BB764406C27017,$4F18DC803D8B3E70,$A931F0A5474372BA
            Data.q $C9ACADB719C5D5F1,$F8E04C4018A41803,$2222107DE68F8006,$2A69BEF78EAA2222,$5ECAE53364F974DE
            Data.q $88FBEECA1DAB72B9,$A30074FA00355FAF,$B3014152CED79FCC,$0FBEDA40822E23FF,$ED33837202BD8801
            Data.q $2FC0087C957AB9CA,$3FB174D45E53C38A,$CB831A7FB5E5B6EB,$27033F0045200F70,$AD090D111111115D
            Data.q $99CC7CDD71BE1E2D,$CABB4ECAB95CEAD6,$CD3E8071E80D0F04,$B480D0F55B287DF4,$FD732BBCF974ADF7
            Data.q $32501306E407EC4A,$E02905BB319CAED7,$F8974DC9FA6DB2FB,$D0628F86B07B6E33,$009DC009A401CE1A
            Data.q $4444444420FBCC2E,$F97F8519CDA77FD4,$47AA93F66968A9D8,$ADDB5FD95BAF6549,$5A266A9A86A67AE6
            Data.q $C6405A50015CAE65,$87BB51923F56C3C9,$48590128405EB900,$0828F84E0A155CAF,$0AE5A53198220A14
            Data.q $0C59F2D5F7ADC67F,$BA4CC2B48035C366,$2222222107DE557A,$EB7829E2E77BFEA2,$5532A861000193C2
            Data.q $0D6943D56C441B0F,$E54C7A1A25FA03E5,$5D01A60078AF2BD7,$84056B90111C4042,$2210D2142AB35ECA
            Data.q $B565FEC7C0D680A5,$6FEE075A3B7DDDFC,$0C6EA1DB3D2A7F5E,$8841F7999C00BB80,$3C9A5A7FA8888888
            Data.q $51CCDE6317DAFD7C,$646BF48F55386826,$8025FA1AB1EAEE46,$B247D2E3A1AF306E,$4880A9874ADB43D3
            Data.q $A05470A06B94371D,$15E1B0D2A0A04AB0,$20A14482BC076A92,$6FC3AD6FE9F1AD00,$01DBC00A0000BE96
            Data.q $B70CE834478734FC,$6A70007F0004C80A,$FEA22222222107DE,$7CDD79BE24753599,$B51D87AA997B34B4
            Data.q $00CEEE464ABF5EEB,$311EFDA752D00330,$C60B97880AE93659,$202D5C808764407B,$2CD2D7E9562B994B
            Data.q $1B7AE370BE34041B,$2D30C7E8F433003E,$0DE832C7E0183F00,$CCCC7C26193200A7,$3FD44444444420FB
            Data.q $D36DFAB845F6FE8B,$A23C133A45102020,$A1A19F407C3EBB4A,$087D3675AF3F99C6,$C2E78DDC140D2808
            Data.q $0547C80044044356,$3EFB70F9ED3A2864,$1DC71EF7CAF810A4,$FBE009647E56DFBF,$1993DC0DFFE42130
            Data.q $6EE00099004B86FC,$111111083EF3D300,$87ECF810579DF511,$8A54A1C6B39CE2E6,$809D3A1F0A56EC47
            Data.q $82C59A97A86AC7A5,$D9586B980A6BC2BA,$6140047EAD221F3D,$386EC859000C8095,$B5FFDBE04B9D34CF
            Data.q $15FDDDAD9BFBFF09,$3EAAD7F80110006E,$9838C8021C323A98,$5111111107C307CA,$F4F86E035C613B1D
            Data.q $DB30C2237C7138E9,$D57723B0F55E51EB,$EB5E23C132CF402C,$2D18DB3A03E7A9D1,$8F21F3D3423F54E0
            Data.q $C155BAF644AED3C6,$FE14FBFF1FF58AB9,$11B957F27BA796F3,$D4D1E9551F801B40,$1FFC015A401EA195
            Data.q $D75444444441F3D8,$E687DCF8B18CEAFE,$7AAF28F8490AF7C0,$A6750115434421A4,$87CF6E1C0D3E3E86
            Data.q $5A572B991EAB9D14,$B247901AB9012A40,$DFFEBFB0FFEDC3E1,$DEE6C9FD7F873F5F,$5F8030E0087E95FC
            Data.q $401CA193D4F9E354,$1115DA72ED46609A,$A69BEF7B1D511111,$A881A5049DAF0DE2,$EE6CD391576992A4
            Data.q $00CBD43563D41C2E,$72BE5F979A3698DD,$88E388E871007C77,$0E140D5880548014,$05CBB0E95A42C80A
            Data.q $BE1B67BEBF5789DD,$00496BFDBD0DBDF2,$87E7DD7E4254C337,$4C22DE18EA868753,$A22222224192E0F8
            Data.q $7DAED7C058D4D53A,$75D48C9518CDE631,$74F5FC60D17647C3,$AE874260A1AA9F40,$7F114872ADAED3F0
            Data.q $02176E33084140D6,$713DBC046B90169E,$7F193CF0E84CF0D0,$FC2ED969FEEF474E,$A1E92DEC575797E3
            Data.q $2FEFA7B800970076,$6E00910062865F51,$22222107DE797007,$5F05A53E99BEA222,$81C7E91A8C7CC4FF
            Data.q $0B064B247AAC5543,$1E0D28BD43433A80,$8E86C401BB9C355D,$AD614483C3E7BC42,$0E849566B9D3B780
            Data.q $EAF9604142918499,$F38D3B2BB3FAB8BD,$DE5801E7003683ED,$DC80314303AA57EF,$8888821F792DE00C
            Data.q $C44EF392E6FA8888,$552DD88CDD39DE47,$EA1ACD1FAA647AAE,$5BA7F8A86AB7406C,$8026442902A73BA5
            Data.q $28109E1FAB61D0D8,$7957AF4B6C2817AC,$5EBFB101534182C9,$940AED7DDE00E1B3,$12BC0107623E90AA
            Data.q $D43560E0BD6ADAC0,$21F7903E008DC802,$520AF7A888888888,$18AF05C2CFF7DAE0,$1F7D260A974A288F
            Data.q $1A89D280A50F5565,$4ED9D287CF6665FA,$01A476F4DCC9B70F,$028DE7F10AE57324,$582B9321D0DD6785
            Data.q $21D4F13C80AD215E,$DAAA841187B1F55C,$3755E9084C27608F,$000BE4014A19BD7B,$8888888821F79B3E
            Data.q $9F5BE22E8EC6F7A8,$346A753426930D3E,$3B350D54E3E7B2EF,$2575E72BB4C91E0D,$E573B59FC79734E0
            Data.q $49E1448B79F3484A,$78F879480348E95B,$D1CBA3F5BC11EB7A,$8034F147A81A5ED6,$367A9132EDD006BF
            Data.q $EF2F7C00FBC80254,$BDEF511111111043,$A2A7A3E97C68DE64,$54DD4611CAA4CBE8,$71A51A57F50D7C3D
            Data.q $06B48B43A1B0F069,$5CAFCA4014E8B422,$427850233DE02D49,$B95EE1F7D264F7C0,$B78A3CEC2F1FFDB2
            Data.q $FA070A1C0E39747C,$E81C1C84A985AC91,$C397200850C3CA37,$4444420FBCCB9D34,$E1264B86F3BD4444
            Data.q $228DD08C9A9C6F3D,$84361EFDD87AA995,$51A94015FA1AB1A8,$43EDB70E86C3C127,$0A3F559429006C88
            Data.q $78FF809CF57ABE3A,$0415EE74DE51E2B6,$1CBA3F5BC0EBEF76,$00F7347AB505F7BB,$EA56B0DECD4018B8
            Data.q $CECC2960059C803D,$0513AA222222220F,$BF5FC1CE0F99F029,$B95EE455C274F8EC,$69D2803351015CEA
            Data.q $95406B43C1A65A1A,$212200991092BBCD,$D3484AE57247EA92,$1F0D878AEBA6BE6C,$E39747EB78850E07
            Data.q $0DFF4C7EB5ED5D85,$C85681D37EB5CDE0,$011FC00930FD00FB,$4444444420FBC98C,$2FB7F8FAB5C773D4
            Data.q $0714428E6753819E,$E24413943E56D08F,$69469674A3424BAF,$A57AB984A57299B6,$CAE57C409657AB9C
            Data.q $B4EE795FAE70F8EE,$C3D7B36ADE021DAB,$F6B6918711F3D4AF,$C77E78C3F8FAAE12,$4A00C5E0283FDAD1
            Data.q $BD4A07CDE3CBEE00,$BCB4D4B298569006,$373D44444444420F,$C0CF9FF77C48FA67,$5CAF647C38C5AD71
            Data.q $0A451014A0A1F099,$413A51AB9D2819AA,$BCE8F86C128D0943,$77700A401B2043E7,$7D850201482A987C
            Data.q $4D8ACA4F014ADE02,$DE12823A3E1C7EE7,$9A91EB6A781589F5,$78013600F9C7273F,$01F797935443CF2C
            Data.q $DE6A71F3D308A0FA,$BB9EA22222222107,$A0D36DFAB889C2E2,$1855CAE654951035,$D694348A23DFA4A9
            Data.q $AAE68BCD9B884D28,$95DAE95BB319C955,$D8CE141B2F11684B,$826C3E405070A05D,$47EAD3CE9A709488
            Data.q $BB3FFBC291840A41,$D3A7A35C399F9B12,$5B64431DB004FFAD,$209261EB90063D7A,$E00101D511111111
            Data.q $42715F0B859FEF13,$AB2C308F1ED87026,$CF34A34F34A0687A,$E86CAD5736943D54,$2214ACA2CC5D65D0
            Data.q $EE4649115A752004,$8169E02C3C28911E,$0BCD9BB0F9EE9782,$D2F9AE14A4AF7CD2,$2AA10CD0627DAC6A
            Data.q $CD9E0025E0025802,$6FE84D6F56FD2CF9,$4444410FBCB3F002,$F5C3D9B2333D4444,$74EE6A4CA70D3A9F
            Data.q $192BB4CC9086CAE5,$8251E2A4E9263D57,$98087CAB2E87424E,$215DAE48F5ED870A,$45FC28176BCAED3B
            Data.q $73E6D959AF48EBC0,$FB5C0D6962AF4FDF,$FE6ABB43EF70C7F5,$9D42BF8025607AAC,$0153901EA7AAC64F
            Data.q $888841F79F8012FC,$8CDC9DA6D8E88888,$31A63F18A5F17DEF,$D7C984292A2AE573,$1AF9D28D26C1A2CE
            Data.q $E9A60947AF4DE3A5,$B5DA8CCA55D98EDC,$20487DF6DCD1B61F,$851213C421B0F3E9,$DF0E84DDBF0F84C8
            Data.q $DFF3E00A4AF13CAB,$73EB99DC1FBB8F5E,$33F3045E0089C6EB,$CE9B620097AADD71,$4444444420FBC84F
            Data.q $E2F809F5FD176C74,$AB94CCCA2C50F335,$27CEDB33CD1B4A30,$84F10421C7E74468,$2EDDA0A1D093A12B
            Data.q $C38124012BA4CCF3,$F80910A042787EAD,$85946838B6BC24CB,$1FFF5C7F774BDF0E,$E0FBE5B71FE7711B
            Data.q $68F0039E0025ED8E,$F901E97AABE907DE,$8888821F79E98031,$9DF87C0027BA8888,$FB8A844F73DAF033
            Data.q $1455CAF72B55EC3B,$2BA74468E63E3B39,$388F0711EAB88168,$739FBCCFD7B2E874,$57A99DA0A0084AFD
            Data.q $9EDA0F21215BC05A,$1FAC35EC3E3BCE8F,$6B5BB7E2FC49FCFC,$C15600BBE7FAA0F7,$AE4010F53BAAC95C
            Data.q $11111043EF20B005,$C6F80B1A9AF75111,$494448CA6331F375,$F156EB923DFB48E8,$9D11A95E94684AD7
            Data.q $CE1B32928F3E93AC,$D7F18325C547CF6D,$4F0F86EE68DB2BF6,$41A4F6140A8F780B,$AFF9FAC35EC3FCA3
            Data.q $1EED54FE7F0FC39F,$4BC015B80235FF54,$D836BD2CF9CDEC01,$320067F006CFD09B,$D7511111111083EF
            Data.q $1A7D3E1B81184D26,$1E2B61BAA6FA475A,$2351A3F54CAB94CE,$84C24A018D41573A,$9D95DA695E74DB0E
            Data.q $E0A341C79B349574,$AC289087ECF2BD5C,$AAF6E6CDA6B7F012,$9FE3FBDFC5ECFD95,$E7F35B5CDF93E077
            Data.q $21F7985800772555,$AB00169007306B7A,$EDA43420FBCD4C01,$417FCC2CF7671987,$F8DEF5F39F600BD8
            Data.q $60E67FC51005ECF7,$688889584BE5D7D9,$9F980A81198268E8,$E3A31FC4C7AFDC4D,$1930004DEF9D63CF
            Data.q $797E938DC7D444C0,$85CE0FB9F063E9F9,$8F386923BFA4882C,$94291455CAF61DAB,$D21A9468E7446BC6
            Data.q $E87CADCA1A1287AA,$66D0E95C4521F2B4,$1A6D5CE8F1D095CA,$200E3CE1B8C83DCF,$E78743952DBC25EB
            Data.q $ED6478905E84D349,$342D3B47D9FD5C5E,$0FBCA3F002EF33AC,$8027FC8039831BD1,$017B090D043EF2AB
            Data.q $1B003AC01EB005AC,$BB62831D09856C01,$8C2612590D111110,$1B30062F2409814C,$270FBAD6FE985CC0
            Data.q $53FAF9DE1264B86F,$FD7B7336EE1E1D92,$699D11AD9ABEFDCA,$657EBD87AADAEDC6,$05200D87CF794743
            Data.q $42BB51D9E1FAB9DD,$BE2009B3614087C2,$DB8ECAF13B86426F,$BBC41CB7C7893DF5,$03F1E7552502B13E
            Data.q $41F798DF4C698368,$2CC1D79006B06A7A,$039600ADADEA215B,$EC006B000AC00878,$799544444444F5CE
            Data.q $01CBC00338026600,$0D0FEEEC5D7F199C,$73839EAEA7C00216,$5478388E84E71ACE,$1AD9D285691572B8
            Data.q $556EB9C3F7B8B4D1,$72BD880AD87BB672,$F57197366D880365,$02D2B95EC401B3C3,$0A3E132AFE0273DE
            Data.q $84AD87C7770D04D2,$87F1F1DE1B7CF33C,$181B83FDAA5ED6D1,$8DFAC74483F6602B,$3C0113200C60C183
            Data.q $007ECEEA24BE5306,$F04C10F74FFE60CB,$7A888889BB83B418,$434859C01F3003C0,$11E682A89EB9A9C9
            Data.q $C464E6A4F05CB305,$5455CAE77386A76E,$BE6F1D11A79D28D4,$1EFDB3AE74D385A7,$01B2B95E9948694A
            Data.q $AF57265A787EADC4,$6915FC24178FBE92,$3C43569576BD23D5,$A3E5BC0EDEF7604F,$1BB3CB9850E071CB
            Data.q $A21F7953E002FF40,$F9C01BB900630627,$1E00C3A506821F79,$E7E3303DC8DFF980,$38DD434444417FD8
            Data.q $A467E600B802E700,$6C8F9B36C61E7999,$5732421A47C2CBF1,$935281F3A828C6B1,$571573A6986882A9
            Data.q $22949CA3A130B440,$95EAFCBCD1B62009,$2892EFE0213C25A7,$D323EFB645F0132C,$CDE21C3A1C4BEE70
            Data.q $7EB51DBDAEC72CD7,$3FE612BC00A0B56C,$147C802D836A0ECE,$279506821F79F5C0,$EA3E1309DE7DB661
            Data.q $268034444448B4A2,$A4813015C014B801,$3E0C6D3ACEB65766,$464266529039A1F7,$6AA68901ED9D7C98
            Data.q $AD223415434AFE94,$6615D0F06CADD733,$B75E3B1006950A9D,$FDBC3E130F95EAFC,$47C34E9E1203DE02
            Data.q $7B480F711FAA77D1,$BB3C61FC7D570947,$024F0F2B8F56ADAD,$053075C7BC830D38,$F7B93A823C015390
            Data.q $2FD00F4C256A0348,$B2A8888889C71A61,$0397230981AF0016,$A5E6CDB237A81D68,$200000CC9401E92E
            Data.q $C23DFA5441444900,$D0CE88D25572B9D0,$B64AAE132758BD28,$C02BA4EE1E09C3EF,$7EAF28F04CA57699
            Data.q $F0141EED47665A78,$CAF134EC95F017EF,$257E7F570A861CFD,$60CF1EA070713ED6,$BA21F791DE005FF2
            Data.q $30C3C01148025833,$7FC0127A78691E77,$859F390D8019F803,$9084C2351EA88888,$12D84CAA9284C2B7
            Data.q $59CDFC6CF5793E00,$ABE76104692A23C7,$7442A43E54E86156,$DB32B84E9C9A868E,$D255D2FCA3C1B3CD
            Data.q $3F7B4EA43F571E6C,$F0FBE922105CBB3C,$7641F809F7784A8F,$000CFE2AE93255E2,$BBAEAF9635697CD7
            Data.q $F2DB802571FD7D7D,$1EB9004B0657443E,$FC017B2F0D15FAE6,$2CF9CC1E00CDC002,$AF0038C943444444
            Data.q $2A45F5F767230987,$51E70DE5CFDB9B35,$2350BA51A11A2149,$783674947AAD951A,$10829006DCDDB574
            Data.q $7C3EFB489E57AB99,$7E12FDFE0205E12D,$56ABD3F45832599B,$C7CDF93E042967EE,$7ACB3CFEAED974B0
            Data.q $3EF3DB003CC017B4,$D30F9C8021832548,$005BF00283C34C54,$888883A7B33F8C3F,$EF0076F0054D6068
            Data.q $CD9A9523DA369986,$1FAA4DD88E91F0D3,$2A8D446BE74A34E3,$361E0A774128F553,$805200DD441FD87E
            Data.q $FD309E57ABD87EA9,$4FBFC04979D3491D,$6EDC770D06943FC2,$3C1FF5F020B77632,$B24F7ABE7AEEDB81
            Data.q $887DE6DFC01EFCBE,$E18B308D200EF24A,$3FE009DBE87CEDB8,$88851EF9D3C78260,$5D68AE60F2586888
            Data.q $31B4EB3D1C4C638D,$CD3050A0E707ECF8,$7623B879F69461E6,$F50D74C7CA994083,$3714A3D542A88D4A
            Data.q $200D204FEEB5779F,$F73BA787EA922D05,$76F0141EF090F87D,$BDC7EE70D323C1A5,$B853EFFE1F81051F
            Data.q $9FD609F7554F17E9,$972887DE49F803B7,$3E736B800AF90077,$7306BE00B5AC0D03,$4444442CF9C82AD5
            Data.q $436F0071F004CC64,$77849DAFC5A000D9,$6EBD3CA1B894FEBF,$CE94292C23DFA955,$AA75424469E688D4
            Data.q $02BB5D2B060BB87A,$B84EC3F56EBB31D2,$7CE9B348451F7DB2,$3B87CF766CF780A5,$9BF17E044254D76E
            Data.q $7C18B3754DD6F8AD,$296C83073006ED20,$ABD4CC3E64019E73,$4C1F73A0D14834AA,$22222107DE6DF8F0
            Data.q $F7800D70004D2EA2,$0B8599EF63F5A009,$7BF5638D04DE395F,$4C93A2346FE88D08,$DD7A443E571088F0
            Data.q $9E321EAB72ECFDCA,$BF788F5ED2142570,$39BF84AD7CE9A647,$7C3D56C3F56C381B,$6F67C0EC0F0FE25F
            Data.q $04FDA838C7E35758,$244015E4683212A6,$6834514D1FA33F80,$704B075017C00EFD,$89DCECB8C8888888
            Data.q $34357729A6F3DEE3,$3DFBB959AF70CE14,$2A17446847060B32,$0F9ED911C099C744,$76A30A900491EAA7
            Data.q $72BD5D3A20AED733,$F0966FE12D7C3EFB,$770ED5B2B95ECB1E,$5FC3E2F66BC3D5FA,$02EC61AF75E5D558
            Data.q $87D55E4283CE2598,$C00079A863E181F7,$13AA22222267F175,$2D2AEF37A325CD7A,$8CD0C23391DCF2D9
            Data.q $38F7E923DFB4ADD9,$3057366D20BA235E,$A1E0F2DDC8ECAE57,$0D8152CA2DDCFFE3,$E22092AFD7A45221
            Data.q $7DF0F849136F9D36,$CFE3CE1B38414281,$17CD71072D86C49E,$2F007DF6547C3357,$90A00041F79ED006
            Data.q $86803B70044E7BC3,$7780256FAA9BDE1C,$0B3E73678014F802,$2BC6FB42F5111111,$5EE79EEDA5B63EA7
            Data.q $EFDB7366A5667A38,$D11AE9ABD5F18411,$4223A12751510AF9,$093012878260A1FA,$61C56FE2236BBDC3
            Data.q $81097366F1200923,$7BF8087396E99682,$0C84D2F848BFFC25,$DF0F55A55DAF60AF,$C4FEEF1DBBBED893
            Data.q $83D631E3CAA1040A,$2415450690373031,$0E4B780337582B8F,$3067C01EB5D54BEF,$D751111110DC9788
            Data.q $81DD7CBD9E17C7C2,$9B3797C60C1C0F3B,$442A67586B855187,$C91EAB72B95ECE2F,$9C376106B9DD7396
            Data.q $2ABA4EDCDDB65017,$E1203FC24228FBEB,$761F3DD880F4C9FD,$1081DF63EBBBAEDC,$D614381C21E6BE6F
            Data.q $FD21A6009DD609F8,$267200EB520FBCC9,$8261BB5FAA73C6CC,$1111107A76600FC7,$0F75E8B0D8E99D51
            Data.q $58D551DB737DDCAE,$0AD02AED3E5E6CDE,$28850879B36679D1,$AB75EC3EBBB7346E,$5425EFB321F1DD92
            Data.q $94051F3DD3A1F7DC,$038EBE1F7D35DA8F,$EA2F011EFF0951C7,$4BDB47210DD76E3C,$A3F6EB630FE3EAB8
            Data.q $2D9836E9F5887FB5,$75552DFEC792B9E9,$F00227AA8FDF8D7D,$7C3077F80066006F,$2E8FFDA5D5111110
            Data.q $48E4B5DA1F7BA7F8,$082ADD73420C6A9B,$88E8E9084C08F995,$2688D32E88545D7F,$40542A88F871042B
            Data.q $4AF3B6EC3F3B304A,$20AB6595BD201055,$01082F3A6D87F776,$CD085027DC28142F,$28F9EDC3DFA4C132
            Data.q $8AB4BE47C6949408,$DE5578011677A3E1,$E70022FA1365A887,$7801967AA8FDF0D4,$AA2222220F4ECC0F
            Data.q $2D4D0BDEB9E97A43,$8DDDBBCF7AB65BDF,$A3BB5192AF53E5E6,$702716A2148BA235,$93A0AED7C4287D94
            Data.q $EAD8D8AF9D1AE6F5,$3EFBA4495EAE7487,$C0407BC250F3A692,$42F3A6923BFB4B6B,$EB9BE67C010E78DA
            Data.q $438A7E358389F6B0,$6A01E7965E000DC2,$01A603B801EE84D5,$F0027F801B47EA86,$11110B3E723B005E
            Data.q $F375B8B2DE91F511,$EE2D0F9BE3C7757E,$8522F45EFDDCD9AA,$004942A3611A35E8,$AE78DC79B36956A1
            Data.q $110F9ED2B76A3A64,$D5CCDD78F190F6EF,$E1B4CB4179B378AB,$BDCF1B897FF84B5C,$E0415ED7F979AB74
            Data.q $1FC03C3F80DBDF2B,$D6002D802268FA4D,$003E40555A8075E4,$8FE3AA8BDE8D7A60,$11073E73A78F5530
            Data.q $F278B2DE83F51111,$A38EFCF37FFB0D9A,$0F376EEE6CD576A7,$ED068B30AF442966,$8A984947AAF2AB94
            Data.q $12EE6CDB0F9EF947,$388824AC04F1101A,$C052B24098090F55,$D23DFB2479F719DB,$D1FAC35CC15E1F5D
            Data.q $D9A85E7BEBF0A792,$E416E00CBEA21BF3,$00D1901516B79634,$FD45EF06A230056E,$EEA2B6601FE006D7
            Data.q $0FD44444442CF9CF,$9ECD787CCF2B86C1,$4E841A98EDEE767B,$9610A841220B28E0,$F4C25769E2B3C234
            Data.q $94012B9E3690947A,$23E7BC4687CF7644,$D48003E5711A180E,$13C3F571787EA922,$9BC79D3715789E32
            Data.q $88EE4DBC241B8BCE,$AEEAF53B5D98ECDD,$F3CA6D375BE3B6FB,$4E411C00A3150E91,$00CBEB05316ADBFB
            Data.q $095BFEA1F783593E,$4420FBCC6C00EFE0,$5CAFEB1D3FD44444,$7B68ECFF7747E7F0,$5D92109875F6C9A9
            Data.q $214F38E07146182E,$D56956A11E2A629A,$F85478270B9A36C3,$AED7C40879F6D209,$E9221D092AED73B4
            Data.q $122DC557EBE3F0FB,$4ADDB8EC30132AFE,$F63E0F72B2FE3EBB,$9C017B4558345C2F,$015D03348DE6A002
            Data.q $F80714007FE00719,$37B284CC147FA87D,$88888859F399D801,$3FA1F05EAC0E9FA8,$58AA1DED47E7BA3F
            Data.q $C172EC3EFB6E60DE,$A89C2356BD10A8B0,$D3220093058B3A10,$61FBDBA0C1761F3D,$FAB881F7DA45CE9A
            Data.q $1F7D3320F7396F11,$FC042F84B4F090BE,$3B5D58E9E5BC25E7,$0EA7C6C7D77CB76E,$51F4C5055F9F83E1
            Data.q $F5AD2C009400234D,$1F007AE405740F1B,$E006D9FEA0F7E01D,$888889319B2418AD,$765F0F9D8034EFA8
            Data.q $3C56C47FF6EBA3C3,$ADFC10A51F366DBA,$5086EC478A557499,$0FECB0F06C3D565D,$A4884147CF661292
            Data.q $5D88F1F95DAF61FA,$F7F2C35F18B06CBB,$3DDDCE5B35EF1448,$3B210E2AED7B451F,$6D08791F2DE074F6
            Data.q $30EFA1D03FDAA5ED,$2074DF2D7764154C,$F7C01C6FB0ED8803,$94C0778025F9FEA0,$4DE98EA8888888E0
            Data.q $BF5E6E2EDD9F1717,$72A9B9836DEBD0F9,$44E885420F366E74,$0F071F910AD5E88D,$C10AA51F09CAED7B
            Data.q $A40A423FC6434143,$4ABD5CE5769923E1,$6CD21F2C15F11E2A,$3A5AFA0D16683F39,$5EA748557ABE2381
            Data.q $30F8FF6DE2123A1D,$030EB9EDC8EDED76,$40E1BE5AF1F004DF,$2B063E1814FC222E,$107C300AE7EFF305
            Data.q $D192E6BD3DD51111,$E87CDFAD77519E9B,$D87C21582A5DA1F5,$C2158BC2143387EF,$752BB31D950046A2
            Data.q $C130D73C6ECB0132,$10C4E8554431C543,$A1FBDA4685CF5B30,$ECC1EE74D246A405,$259C407B8DEEF0F8
            Data.q $DED57A9D87D77683,$63E1847BAE7BC251,$E1BE5A84C0007DE0,$0193F0044C80F540,$021600BDBBEA7D7C
            Data.q $44444441CF9CAFF8,$96D569315F37A055,$A6597B6B6ECFA5F6,$207104157499DCD1,$AE5E08532F446929
            Data.q $00923CFB8C234210,$7834894AF1327422,$7EAD8421F3DA7494,$664399B765769854,$AF883F2C35EDCE9A
            Data.q $3A1345E6CDC7B55D,$8D6943EBBA47DF4C,$91CCFCD8A3F3FD0F,$771FC5E1B0EC9F1C,$1D7202AA070DEAD5
            Data.q $72F0066D183E78D8,$44444420FBCFBF00,$D0FF9CAE1B1D7FD4,$6E7471DB6D0F43EA,$14082150823854E0
            Data.q $888264A08E85023A,$63334E08502F0856,$ACAAF57247BF6D75,$CF6655A4468251EA,$495EAF72BF5ECB87
            Data.q $EBE377A3B087CF77,$58778490F8A24A57,$E70DD87C36E60D24,$8FFFF3E00A40415E,$AF8C01EFEC6BCE5B
            Data.q $4C026285440D9BD5,$1E67A90E4B56A3F5,$083EF3E7803E7004,$0B0DD1DFF5111111,$0E075DEF6AB65FCF
            Data.q $ABA4F1568992E385,$F22AF53B0ED53020,$F04E49C2158B8215,$3A45064B255CA670,$87D76701F1DDD77A
            Data.q $F190FD5B95C26610,$88F8EC91F7DB2B15,$A2447FC042FAED47,$CDDB8CEBAF1E2DB8,$46D37F5C4828FAEC
            Data.q $C3B47CF3DBBDDFFC,$78B50FF7AFF30F91,$FDEC027C80A881B3,$EFD80170016E6C18,$775D1C2434444441
            Data.q $1DFFF778781E9BC5,$E56E572BDAB51C3E,$423046A187A036C3,$3DFA609C2142B821,$220995A855BAF882
            Data.q $76E78DC79D37654A,$A3C5491EFD5760E9,$8083C3EFB373A6CB,$1050A24A7FC24EBF,$374BC3E7B8DDB8F1
            Data.q $14FADE7FC49E7B9C,$FF2734ADFF8BBB6E,$02BB55C06342B300,$60C7EAC0CFC01E32,$7DE51001EF004DF2
            Data.q $8FFDBFEA22222210,$EFFBDD1F07B1FE5E,$D0DAEA4760BA1D1D,$9C704691879B36E1,$79F692D446B97442
            Data.q $F3D9C8AB95EECFD8,$257499C25C3F7B61,$80A3EFB8AB35C5D1,$55FC3C1308A3EFB4,$0F95B5DB8EC3DFA6
            Data.q $DFEFEFC86A9220AF,$7FCFE3F2F9E72DC1,$6FDE18F6AA37E81C,$EEFA935F9558F800,$444410FBCD5F003A
            Data.q $8EE58B17FA7FD444,$1FFDFAE8FDBFDB93,$15749A546434A288,$150B82148BD11A46,$A8CE9223DFBB2F22
            Data.q $A00F9ED5D1C2B8DD,$6E2155BA78DDA8C2,$87C34EBE1F2B7730,$CBF78A25DB8A05AF,$FAEF979B36DCB9A4
            Data.q $47B9F03E3F7EB558,$520BD9357F3CE5B9,$360DFF0068C80ACD,$BCADF0041F160F9F,$97A7FD444444410F
            Data.q $ED7CFC28F4F8DB9E,$DCAE533A1EDF0713,$69A670ABA4EE5789,$BB11D22046A48F38,$286848852A11A925
            Data.q $BF150F55C79934C0,$A65769D23FFB8A97,$365D9E1FAA705202,$308AAE53C60A9768,$C25FB0D12D7CAED7
            Data.q $0D1695F884AE3FBF,$70786D8FC7586B9A,$4D7495123C1F7BC1,$010E008AB750FFAE,$203D9AA4DF206FB8
            Data.q $BEA3D7C552D004EF,$3EF35FE005DE0051,$B75E9FF511111108,$9BE3F778B086CC78,$AE657498BB0A2E0E
            Data.q $9C1094978E8F9960,$3DFB7023E13A10A3,$EB43E7B32AE13A44,$BDA40FD532AF134E,$1B0FFED90425491E
            Data.q $DE327DDE1223FC3E,$D87C388F6ECC21F5,$8DB184E2415E1FBD,$A0477179194E676B,$752F9E3CAAC01AFE
            Data.q $00AD50A0B8063572,$7D45AF4ABFBC0122,$FBCA3F003BF80117,$1F477FD444444420,$F9FDF6A7D1E5305F
            Data.q $6ECC69515EDAE7C9,$099508E8542AF532,$978E81E6CDA6671E,$22E78D991E7DC60C,$F65C415490143C1B
            Data.q $C79DB64EBF8895EA,$52BC25AE74D32421,$71D21428143068BC,$BA358EBDA0E976BB,$C58B88F27D3ADFD5
            Data.q $079CFCAE610725B4,$0136552F1F0D5960,$4015AA0DF207EBC0,$7D45AF4ABD30052E,$07DE45FC182CC013
            Data.q $2E360BFEA2222221,$C2F2FE07F5D1FD38,$1D30AB44C9D9F68E,$C70AE30F356C9BB3,$BB7366B2ECE10AC5
            Data.q $2F1D251EAB9D1CD5,$0F9ECE03C117441D,$BB0F9EE3A0A3EFA7,$087EA987C766106C,$AEB4789015C40FF8
            Data.q $0E1535347D7770FD,$B6E33162E2399CCE,$006AF007EE5BCEAD,$3D5DEEA5E3C1AA7F,$954D7200AD5E2F90
            Data.q $8025700026FA875E,$EA222222107DE75F,$4797FB9D161BA3BF,$ABA1385F77BBDDF6,$BC212BC3E549BB31
            Data.q $3E603D5714982142,$1F30FCECC3DFB8A2,$F33A16878361EAB6,$4ABD5F11FFDB4961,$064BA757723B8882
            Data.q $77F090AC7FF7113D,$8F17B9B36C8EFEDA,$4633F982162C6DE0,$7F0ADAE776986C2E,$0D40F0012E00C3F5
            Data.q $4063F8ECED75331E,$156E7005CC802354,$182B780146FA875E,$C78E84868888883E,$1D77DDF2C0F45CAF
            Data.q $87EAD87C764A523A,$C21408E84A08E8FD,$2556304281608566,$7323DFA4E822AE93,$93D1C0D87AA9CAE5
            Data.q $AF48BBB1D20087EA,$5BDD11B65829D95D,$32ACD732253FE027,$46B379915537C3E1,$3CDD3DFB7D9FD07D
            Data.q $1E0062B210983682,$AB85EA0787DCF52F,$E0D5D7C8FD584011,$C8E121A222222BB5,$96BBE5A7FF7F05BA
            Data.q $0D23C56E8A9477B4,$1F09AC70DD98E922,$6C3EFB6E6CD328E1,$EF1455CAF6448908,$51202D08782AE8FC
            Data.q $B729E57AB9C3EBB6,$4A7C5025789DC3DF,$66D23C1A7E83659A,$E47D3B9C1C2C9173,$3C1E83F6DDE79B57
            Data.q $DAB9B0062E00838A,$483F4C116C7A98CF,$637801348037F5D5,$FF0055F27D420E35,$FFA888888821F79E
            Data.q $DF2DF7D3FCBAADF6,$223E1B492820FDF3,$2AF13C474755EAE7,$08572E08524F0854,$7BB9B379470A9847
            Data.q $7E51E0D87AADCAE5,$DF5965CD9B65CAE5,$E278F3A6EC884147,$EBBB387BC25DB795,$605AFD82BC4156C3
            Data.q $9DFA751EFFE6E4DA,$210986EC91E2F5D7,$700454BA8293BA03,$22C8037F70BC40D5,$53E0097E5E6EF470
            Data.q $47FA888888821F79,$B8DD9743FB721E7F,$D76634EC5F7DD1EC,$0856CD5E2777346E,$DB2BA4E90A08522E
            Data.q $4955CAE70F049E6C,$B0FD5B0F055D1FA4,$4E576BD3213C3EBB,$5FB578993AFDB9D3,$B877F71F84A0F8A0
            Data.q $1C4E931F5DDD76E3,$87D1DE232D09CF71,$FE835CFA619BD80D,$8BC40FB793EA673E,$585C001FFA1377F6
            Data.q $5519872CAF50838D,$A888888841F796D7,$1FF6E7C5C5BAF4EF,$AA31BE0E27DAF1F9,$D602648E86D058B0
            Data.q $BE23D57119D10A59,$EA11EFD93A12556A,$A1A1687AADB9A36C,$7110F069148772CA,$B2B94EC3D7BBB923
            Data.q $0FB9B34996A28F15,$0D12F7FF09368689,$6DDA0D9761DBD325,$DAC36C7E3222B6E7,$B76E3C657C8CA799
            Data.q $F3F8FD67E004DEAF,$6AB3D9F9872F77D4,$A0EF80127D09B3FA,$F38033677A8621FF,$44444420FBC81C01
            Data.q $DB4D96E2DD7A77D4,$922BA1CB61B1DD0F,$911F099E74D3874A,$44214F3042AE7842,$F11EFD65D23CD9B6
            Data.q $095B2E95E70DDDAF,$DE23F7B74B9C3661,$88034C9E02D05E6E,$9258A3E1A47C242F,$0FBED9B7E12BDE28
            Data.q $56E8D62AF48F84E1,$E989E7CDA99CEB7F,$400C7AE3E7EAEEB7,$F80210F3BE1FF807,$DEB0573FB05F356D
            Data.q $5306D7BD4F3FCFD2,$3AA22222485DE486,$0773DD66385F1FA6,$DBBA8BE1F4F4DEEE,$C212A8742811D1F1
            Data.q $F2ABA4E99982148B,$572BD99FE610F366,$3A6CE8345923D56E,$09C155EAF61FAB77,$B91DB9D34994BE1F
            Data.q $B787D76652BC4C9B,$F7C3E1BAEDC6645F,$70055F1FD1F5DCBA,$A88DEE7A8B5E954B,$B9018804FEF466F2
            Data.q $7935802F7ADD4613,$AF4EFA888888821F,$7E7F43A6E579345F,$6951F0DCB3B6F9E6,$3A144B82152847C7
            Data.q $CD9A9D574999514E,$06952BD4C957299D,$2AF53B2BD5EC4A8E,$7140B9D36DD83859,$995E266443BF8485
            Data.q $FBE025789E3257A9,$762ECAF2359FCD52,$F2A86C003BC7F47D,$AF1D2CC0C6F7526B,$AECC00B39006BE9A
            Data.q $4FC00DFE98E841E6,$5DF5111111043EF3,$E070DF2EE62BA6C7,$D06DCDDBC577DBCF,$2F023E3BC55DA770
            Data.q $081E6EDD3135749E,$72BF4F110F366995,$01F320687AAD87C2,$FFD247EAE2ACD7C4,$5F73A6DC3F7A6401
            Data.q $D6AF1334843A1348,$C795E72DDB4FF849,$57AD39FCC49EFAED,$C23C00E3FF6F33FB,$AA76A99FC61600C3
            Data.q $356B79006BE8785A,$42B7DC0CB4C7410F,$9E17C7C2D7544444,$EDED77FBC1E57CBD,$47C76660C1695498
            Data.q $93A71C2150B042B3,$F8F366E950815749,$8714A3D542A9560A,$F57E525480F4C00F,$4CEE74D93CE9BCAA
            Data.q $FB4DAE28939FF2BC,$EFA0E1772BC4EC3B,$6B9031DEE63EBBC5,$5E76A84254C03602,$1004BE8AA9095303
            Data.q $A63A0075ABEBC00F,$8888E7E3831600DD,$735E0B13FB56EA88,$1C28703EEF7B23DF,$1F1DD94611EBDE53
            Data.q $BA6B79BB664BA31D,$7CDCD9BB0F86C3DF,$274250F55B0F86CE,$DF5947EA8540961F,$7112BB5C9E74DD87
            Data.q $2FEF013EFE021108,$ECAE53244F5DA8F1,$8FAEC3E9015B5DB8,$3EF06AB7C005BABE,$D62F5AAEBC011464
            Data.q $3AD5F18021720097,$6A800378014B7500,$1D8D511111116F35,$F3DB2FF72DE0B75D,$7376F95351A3B6AB
            Data.q $428271F1D93060BB,$80F7EE2230468578,$2B95EEE6CDE51F09,$DF4DD1E0D928F55B,$F6E1B0987436D087
            Data.q $9D95DAE4F3A6D87D,$EFBE6BDFE126D578,$4E24AFD7E51EBD25,$09F57D1F5DE7D89A,$AABD86EDEED40F00
            Data.q $B57379004BEA80DD,$C9EE00EBE98E9CDE,$0737D444444410FB,$DF762B7DD0F82F56,$8EC182D2AF281EDC
            Data.q $08564E0ABB4C94A0,$3B87C774FC08D52F,$2AE57C47BF53B76E,$8843CAAE53387AA9,$C3EFB657ABD87EAD
            Data.q $CAE57B0A0C974C87,$99423E1309157899,$F1ABF5EE1FB2BC4C,$A179B13E4ED61B63,$9822363796A4B798
            Data.q $B3873DF0D7F74B9F,$EDEA178D5C980157,$A3CAA1370026901E,$4A774B3035A2A8B8,$6F7A888888841F79
            Data.q $7BA3D9617F97A3CF,$A60C1788F3E99ABF,$C10AD9DDF8F11F7D,$878F6C08D4A10A79,$D24A3424A3EFBCE8
            Data.q $22D0F153692DD98C,$BC44DA0BA45A1C0D,$95DAF8C8280043D7,$EFA73CAF57C47EAD,$AC15F1E6CD3487C3
            Data.q $9F7144BF78A24962,$66286AB75E98B144,$9BCE77F48EB6EDC7,$C5F47D76154E72D6,$C0D3A634C02F0001
            Data.q $015B7A9D542A89DB,$1D29BEFE96802D79,$220FBECBB9198293,$7E5CEC01A33AA222,$586CFBED57CB0DD9
            Data.q $850CFCDDB8A8F156,$247C24AA40851CE0,$572BDB9B342AAE93,$C2BA21098251EAB6,$557AB991FBDB27DD
            Data.q $B73A6D87C361F7D6,$329DFC25AB8AAF13,$8EEDC767E8B76E33,$597AD19DCDB42C68,$1BC04FC5F47D7715
            Data.q $D788BC6A86F2B523,$0EFF1B5974CFDFCB,$88EA8888888AF933,$37A3A4EDB962C5FE,$6CD9C8AAEFBB5EAD
            Data.q $850AFCFDA0D969DE,$25420479F49D54E8,$0D01EFD65D237723,$7434E80D5DA8ECA5,$356EC409A4486828
            Data.q $F0FBE92352035F37,$66DA0D9788F55C44,$E57AB995F094A2F3,$91F3DF2A6FE1213F,$6ECFE605F45BB71D
            Data.q $78F3CBADE6717B7D,$31BD2DB30BDE65D6,$C35CC3A7710C83EF,$582B9BD22F3FB67A,$DA0762FF821F801E
            Data.q $8841F791D7A09836,$C5C5BAF4E7A88888,$81E376B3FF6D0A67,$6655E2670F152537,$9C2140B8214960C1
            Data.q $05749D3A97366CEB,$1EAB70F84E1DAA65,$0F6ED8782610005A,$88E261DFD3100711,$0F2BD4F1BB31E327
            Data.q $58D36BE0212BB5F1,$C028834482BB5C9E,$7C6280BCB0D02EDF,$B6E91FAB4C58AAC5,$79AEBE8E67538173
            Data.q $DB9771E9C83FEDDE,$0C83EF20BA7C530B,$D02F3FA878034F03,$9FDD1800E7582B9B,$BCC1C01AB91EA337
            Data.q $57A73D444444410F,$AD5FA1FB69B4D65C,$EF376DDD75E07CDF,$2156BC10A5021408,$87C3CA88F8EE919C
            Data.q $87C36222A690FBED,$DA79D0A1A0A56EBD,$AF57A401FAA6D095,$4192EE1F7D991684,$0407795E276E74DB
            Data.q $37346D82FC2407FC,$329F4EEDC7CAAF13,$AD6AFF6FF3AD27F2,$37B5401D7C31F39F,$7A05F7F4576753AF
            Data.q $12FDE06AFD784013,$888888821F791DC0,$FBE3F460BA3F4E7A,$F2A2F87D3D36BB82,$B0F376EC407B61F0
            Data.q $87149E10A15C10A0,$EDD068B26ECC788F,$438A23421EFDB0FB,$7193947C903E4A89,$EBDB0FBE990290E0
            Data.q $18A3C1307B9D3761,$7576E3C4762ABC4F,$EDC7CA3D56D76E3A,$731F8D4F786A6F8E,$858FCA83DE00444F
            Data.q $6F612973F41CE7AA,$A63A2379FDE5C802,$AA2222220FD530C3,$70BD8FF1C2F37A13,$A555791ECF53E964
            Data.q $F09A2C3D01B70F3E,$6634A8F849578C11,$8372B95CEE6CD337,$E34C3F5491093947,$0A3EFA48121F09B9
            Data.q $211015255E26645A,$BB7E02A5BC0497E0,$7B18FDEED76E38A8,$35C586D8F279BF9C,$697A60CB1BDBB71E
            Data.q $ACFAA9833078E069,$2FEE69540CE401A7,$222241C2E06BE975,$72BC9E2CB7A1BAA2,$E9E8E17B9F7BA1FD
            Data.q $111F376CE8474315,$9D0C182E931F376F,$46AEF478E87C26CF,$F0D911A10FDE9CA8,$DCF1B65C3EFBB3A1
            Data.q $CE9B8F376CCF386E,$4996AF134EAC15ED,$0AB8FCAF13B307F8,$4F761734B6EDC762,$DEFB7398B178DA9D
            Data.q $1BB80CF95EED3FDA,$034F5466EBF5A064,$0056D31D0E52BF48,$D444444410FBCADF,$F57CBE9CAE5BED33
            Data.q $6DDB3ED9D85FFB9E,$11F09874775FB734,$46A1708548C10A46,$744213B43E1C6B47,$2B95ECF366DC3E1A
            Data.q $C09C3F54E03A1D74,$7CA3B7B8FC3EFB61,$25A578998427B9D3,$AF13CED6FE12D5FC,$85F83409E7B9B36C
            Data.q $FD38D0DF23E9D4E0,$2F6F7BB0FE6B9B97,$22EE21887DE62F80,$E401A7A26E9A7EF4,$00A7C8F501BEBEBC
            Data.q $3A222222087DE5B4,$DCAE57F38589E0B6,$29F2E4C1BDAEFF7B,$11F5DD87C2684157,$2A4D04681708518C
            Data.q $4E8488F8EEE57699,$05A0A08F366D87C2,$AEE2A3E7BB0F5532,$CE9A2EBCAF570A8F,$FE1210FDEE23C54D
            Data.q $84AE53E50DC50253,$FCC7E7648828FBE9,$9EBDBECFE5DEA339,$3EF327802BFC6D76,$FEBECCE002D610C4
            Data.q $F457802290049EE1,$69F8025698E80DF5,$0B63A222222087DE,$DEF72B2FFB3A2D36,$55729DC13840F7BB
            Data.q $A15E31D0A04775FE,$447CAD31A08532E3,$B2BA4C98365A7742,$B064B395CAF6E6CD,$572BD87EA922149C
            Data.q $E9A951EBDDAEE476,$E025DBC45569D3DC,$3B54DF0F7ED3243F,$DE7F7F1795F278FC,$BD5B7B988EAFD68C
            Data.q $87DE44F80012ACFD,$49EC1FEBEDCEE218,$3E9031FDDC1B3900,$F41A2222206B4E0E,$DE1F9FE1795E37DA
            Data.q $7036D1A3878387F3,$94A08E8D4152C944,$08512E08524C7FF6,$B323E7A72BA4CE8A,$207AADC3DFACA3EB
            Data.q $EFA655EAF712BAFE,$3F3E6DA2F3A69BA3,$89D217E127DFE028,$BA236CF3DCD1B657,$FD3A8CB72DC9D4C4
            Data.q $16EAAB94F76AEBCE,$A90DF3EA40F3B170,$74E2FAFB7390049E,$112672A7A8000F4C,$E5E16EB1D4B0D111
            Data.q $A247C39BF5DB2FF7,$A50476A93CD1B716,$8562E08554D60274,$2BD5ECAB9BB673C0,$DCFDB37366DC3E1B
            Data.q $F6CFD87DF4E1F5D9,$8EFEE2F6BF8C95BA,$F65749DB9D372A02,$E2810EFC042795EA,$1B2BC4F3A97E12BD
            Data.q $2C4613C4C482BC3C,$EA60142BDBC0509F,$2AF610C03EF217C9,$FD840127A40FB1F4,$222220A7FF87031F
            Data.q $3F96F05BAE8EE41A,$E8A9477B7B73D8AD,$86DCD1B4A28F386E,$042A170425598E90,$387C76CAA1EDD9D2
            Data.q $5572BDB9B36CAE93,$7DB95EAF712A3C1E,$B514083DCE9A951F,$12BDF9E34D28385D,$DCE1BB2BC4ECD1FE
            Data.q $ADFD23518F9E982B,$ABF99C44BE6C4CA7,$79E5801DFD51EF7A,$5F5670026A88621F,$15CC234802B1E0FE
            Data.q $F798FE0065BEAA2C,$D6476BA888888821,$71FEEF0FBDF77C2E,$C36411F2A6649410,$E78429A7042A1847
            Data.q $05E7752460B164E9,$E1F08544AE93E583,$FD5B7356CCB41C2C,$9A951F7DB95EAF48,$2FE121455789DDCE
            Data.q $8B32BC4ECDEE2897,$77B37340B9D36D06,$4B198B1711ACD670,$C1FF89ABE8F8E776,$AC743F97DB9CE077
            Data.q $AE5031FFD8167200,$B5D444444400FBCF,$BB15FEE07C166B43,$DD050BBA5A04187E,$7C214CBC7C24F3A6
            Data.q $7CBCDDBA74381C45,$8F84983A5E2947C7,$9956911A0955CAF8,$DF4E57ABA74951D0,$373A699901EBD247
            Data.q $A7C5028DFC05CE9B,$345995E2765769D3,$CDE6A97D16EEC668,$D6D73BB4C343796C,$CFAC016FC4D729E6
            Data.q $0FE5F4DFD44310FB,$E00B3DF5508024F5,$95444444410FBC8E,$C8F03D8FF2F47FED,$E1F2BCA340831B9E
            Data.q $0A95E085230C1D2E,$B7CA21EFDD3A99E1,$B95F1855D264EB9B,$B8A8007AADC3E1B2,$F4C88521FABCBCE9
            Data.q $908305D95DA6647D,$FC25DB8A242787C9,$6E3B7DF2BC4F5D95,$AEFC7759C6EAF5B7,$01F798DDE07C0FE6
            Data.q $BEF2F582B901A886,$BCA2008DD31D28BC,$5BED9D444444410F,$37DF6AB2FF67C579,$ED068B32361B30C2
            Data.q $2E9C5E3A1573DDB8,$1E29743BCDDBB417,$5CD9A15447C26BB7,$25C3C14A8F55240B,$1F7DB87436160985
            Data.q $BF5EDCE9B6FBF885,$E7FF8080E4556CF2,$1482AE2F7CAF13CA,$73CD6FF91D4D6604,$FB1AE73D5AF7F8EF
            Data.q $30068C207D1DB829,$CFA40158E87FB7B3,$23FE00ED4BA8460B,$BB675111111043EF,$F3DAACBF95F65E57
            Data.q $98345D95D26CB085,$C10A35E085287CF4,$223E3B4ADD78ECAC,$572BF28447CA93A5,$57A75CD1A48F075D
            Data.q $54AE57247DF52AAF,$EE82F2BE4ECAED7A,$9CA71257EB995E27,$583E1A5BB1CBF4D4,$1201CB876B5D47C3
            Data.q $4144490020000019,$F3AF4A06BF9FC154,$7D29801C64017742,$88889C0985750A3E,$ECBF2E7600D19068
            Data.q $E9451B5DF6ABE586,$32504779CB772BB5,$C098A63E3BC743E1,$7C77674421A74111,$B48F0711F7D9CA84
            Data.q $365C3E6742D01CD1,$90F87DF6E1A0D87C,$34A2F3A6F28F8EC9,$79DFDFE1257CAED3,$C6AF13A47AA995E2
            Data.q $5BD37C713B586D8F,$DF64BDF50C97EBC5,$98DF5E840DAF7705,$6E3031FAB0802EEA,$D29444444400FBC8
            Data.q $AC56F7E9743FB600,$66E91F1DF291F7DD,$52E0850880A992F3,$E900F376E945E085,$D7663B87D764AB94
            Data.q $74057A9E3A573669,$FB640BB31D961C0A,$0D9788FBEE90043E,$571D0FAEC9E74DBA,$5DA76577140A563F
            Data.q $48E464154D76E3A5,$D310AF1B93CCF77F,$D3D1CEF3D5AC1C96,$5EA08621F79D7E00,$5480308796EE8667
            Data.q $4444440C29C11FDF,$49FCF962C5FE8683,$20AAFFB759AD376D,$413B98369D430854,$65E109443A348C24
            Data.q $381C55BAF8F8C11A,$C7CB0AB35F120092,$0A1E0D91F2B76AEC,$A4F3EAF1160D7FE9,$140A4F0FBED91CD1
            Data.q $44F2B55EC3EFBA54,$2DFC407BA74AE93C,$E09228BF0946FE02,$217E0D5789D979E1,$EDC66295CB667538
            Data.q $00DBE7E7C1FCD64F,$30E9CC4310FBCF2E,$0ABBA97571EE33FF,$9FF72A1C7DFB4BC8,$BD0C888888801F79
            Data.q $B67EDB13B9EF5CF4,$6DA747C29D03F1E6,$1F09BA2BC21285E7,$98508F871572BE3A,$B61EAA70F8491F9D
            Data.q $96D4FEE6B4FEC3EF,$F0929E1F7DCE9186,$3F68BCE9A951F0E3,$662868961FF092EF,$6E753ABC4F96ED47
            Data.q $E1ABEFDB8CFED5EB,$5084A981EE0C1F23,$D03F9BDD980134F5,$32A1677FA339005D,$83444444BBD1C187
            Data.q $6237B4F8B8B75E82,$87C368DE074DDAC9,$F815749D30C2381B,$DAF65C608D02E10A,$0850E6ED923E1B95
            Data.q $63C55CD9B6BC31E3,$4886826728F86D77,$B644880AE2155EAE,$E7FE3F73A6BBA3EF,$BC4F63BEFF0161FE
            Data.q $6E73CD3BE5AD3D9A,$00FBCD3FD94DAE1F,$4015754E6EAF5043,$E390B3FFDC9801C6,$8888821F796D0016
            Data.q $B2DC6DCF4BD3B868,$E05A1E37EBEDD0EB,$1E72DD95EAF70F86,$D2E382350B842834,$1F0D87AF4E00F326
            Data.q $C38A3CD9B70F8ECE,$44A8F93A50F55247,$70FBECEBB91D910A,$D36876AE3A8BCE9B,$FE28943F0969EE74
            Data.q $F11C4F26AF13D8E9,$33E5A9AF1B9B31FB,$A08601F79C7E641F,$7203D57737E6F497,$7DE6B759420E157A
            Data.q $B8AF4EE1A2222200,$9F9B57F081E369AC,$BC4F942A107E7C3E,$682148C39F30E8EA,$D060BA6B55DAE654
            Data.q $D2B55F14A0779A36,$BB11D87C372BF5C9,$EAD20702AEAB95C9,$3669D070BC642787,$74DA478261BAA617
            Data.q $ABE021CD1A690BEE,$EE91FE12FDD5FAF8,$D278DC531D8D5E27,$C4FC86ABC58BCD89,$A9C016B0066CEEAB
            Data.q $E87655E908641F79,$1875D557EBC202AA,$A2728888889D01A6,$AEE0BEF8FADC5D37,$858E85268E8F849E
            Data.q $F3287C34A5ADED0A,$0DB0F84E842503B9,$BD961F0ABD5681E8,$3EFB382DDC8EE57A,$7ABE3CF1B6E74D32
            Data.q $8A05ABF80B9D3665,$79E5789DC3C1B33B,$34A7A9C1DECDCD02,$AF0B1D5E264C325C,$015743B2AF5757C5
            Data.q $05987BF5D5E80D84,$E8FD039444444484,$A9E1FD2C9FEBD182,$2CBCDDB32ABC8F67,$C10A2D1D0A04747C
            Data.q $E221F1DE25A08502,$F376CC3E7B610FBE,$47C36E6CD395DAE4,$94961FA44A1F09C9,$ED95EAE4887EA9C2
            Data.q $62F3A6ABA3E1B0FB,$FF8494F8A243E1FC,$995CAF4AB75CCCB8,$4733F9AA5F455789,$FD79CDCBFE9C6C2F
            Data.q $4300FBCF6E64183B,$5DCDFD3DE9802B4C,$EEC50B39D5F99005,$95C344444400FBCC,$DDB7B6C7E8C9735E
            Data.q $70E06CB3B6D6F4FD,$87171E11F0DDCE9B,$C3954E047434E68F,$CDB3A8305DC88F86,$762EA879F69125E6
            Data.q $5DC8F979E34E007D,$F57279D352BCD9A7,$A6E5FC04BB78484A,$9DC4056DCE9B61E2,$B3FB0FD6ECDA7578
            Data.q $5BD07D4F76A7B96E,$7A621887DE6B6009,$245E8910052A1F9C,$44437A5C08A63A18,$C798F16EBD0B9444
            Data.q $19DB5B6E7EEF0F9E,$C215068BCEF366EE,$7888C10AE5C10AB1,$215847C315D4AECC,$11E2B655CD9A647C
            Data.q $F57B87EAD848F7AF,$79D352B064BB224A,$161E0E964F3A6E31,$7DD3F5E68F1FDE28,$CCD5E264888C261F
            Data.q $BFC7779A683F2DA9,$7DE65F83D7D1F8D6,$A5637F4F66662180,$DEA4282FDD193200,$44410FBCDEC01079
            Data.q $B71B2E27E8DC3444,$7B6847C29DFD99F6,$5C10AF1E12209C3F,$A8023E552BCF1A66,$33A08C182F947C24
            Data.q $A3E48168684A1EFD,$EFA9D100AAF57B9C,$F373A6D9173A6923,$8F84D287EE74D33D,$772C15C9562BDA48
            Data.q $5C69FC4713A4C7E7,$C4EBECFD6B07E363,$A7AD3310C03EF2AF,$BAA3F560D052B1BF,$C344444400FBCEEE
            Data.q $F627EADC78B4DE8D,$198FF3A38EFCFDDF,$3EFB362E08544E3E,$96E91E9DE288F86C,$5E91423E1C528D73
            Data.q $1755BAF61F2A4AB9,$9914A5050B3003A1,$0FBEE23B56D257AB,$60983DCE9B8AC94F,$283FC245FC7EF492
            Data.q $15E582B9DF0F5533,$42793E6FE71EC604,$87D35049633162F3,$FFC2A9B983EE3F5F,$5A9901EAFD1D5EF0
            Data.q $1111371FF99083C5,$EADC78B4DE88D511,$7C395EDD6E96FB8D,$096263FFB4A50474,$94BA1D1F0E74971D
            Data.q $5E6CDB7376CE1F0D,$EF69D2878ADC3E1E,$84F2BD5EEE66DD87,$83659910A43EFA4C,$02B590D5279D355D
            Data.q $95CAE65789D96DC5,$69C1DECDCD202A4C,$E7764B198A179B53,$9E5801B43EA12FF2,$1990057E908621F7
            Data.q $59600ED770C83C55,$F42E1A22222087DE,$EF7FD86D57E385E6,$3879F64D4FDA17D6,$77A03494A08E8ED5
            Data.q $E85046897842549C,$28F84E8345923E1C,$3C13003E1E51F1DF,$7DB95EAF72E1F0DC,$F11F0F55A458261F
            Data.q $F3A69C3C57150F8E,$C169D95AFE12F3E2,$CD5E266BB7193160,$5F6FD30DCDF23E9B,$F794FEC75EE7AB5B
            Data.q $F27B1A0089908601,$F1C0CB581901591B,$BC9FA135444444BB,$7E7D2D0E1BA3FC7C,$748C23E1E5B9D1C7
            Data.q $97263A12823A3E12,$0374E3C411AC5E10,$AA108F87955BAE61,$47C38ABA4CC8F853,$AF57B87EADC3C157
            Data.q $9D36DCF9B70FBEDC,$57ABE3A5769E2A7B,$9D983FE02FDFC242,$2AE23E1C6415E578,$344FA8E66F302788
            Data.q $57867A70039DB9CE,$52A23987A247ABE5,$FBCD2CF5480F6100,$B75E81C344444400,$DB6EF76D75CAC278
            Data.q $F87955DA7CB73EDE,$D093A35F08564E08,$B0F86EE72DDB3F61,$5488F84956A1E64D,$C545D20BDC64441C
            Data.q $28FBEDCAF574AAC3,$179D373A3EE74DC4,$78A240FC25A784A5,$202A48BEEA0D349F,$FD3E78DB0F04DF45
            Data.q $6FF6F8BEB49F96E4,$60020F0D0FA1E4D6,$AC4C8039F4F54C8F,$11107FF6338641F2,$9584D17EBD300D11
            Data.q $ECFB47617D2DF65B,$538F84DD4A885420,$7C22EF346923E1B2,$5447BF7167FE3A04,$1FC55FA66000F556
            Data.q $EA6CA07EAD221496,$FDCE9B8FD06CBC55,$EE76DD3AFB9D362E,$479F71951FE12FDF,$9EBF341B2CDCE9BA
            Data.q $F7C6E6F8D971BE38,$5803B59EA0AFF0E4,$88E51E908621F791,$59FEAB8C012200F2,$88889A0FFE052586
            Data.q $647C4F970DE94068,$F083D9D85F7B81D3,$D1F0EBA8BC215531,$C3CB7663B87C2151,$210D30A4B0E87947
            Data.q $F7D93064BB2BD5EE,$7CE9BCB179D34DD1,$84DCE9B65771408D,$46A3027BE1F7D30F,$6265CB51794F5BFA
            Data.q $AB5E7F01F55E271E,$C763E54DF93D099E,$79C3803367AA3E18,$4FD2A8688888821F,$B74BBD86C8F89E2C
            Data.q $C8A3CC9B6998EAEF,$4A08EF3C6F182C59,$AED73A178429A608,$07CF6DCD9B6200DC,$4128F8718305E754
            Data.q $0AC8684A1E0D3A03,$ECCABD5ECE857773,$D22E74D2480388FB,$C75155FAF8C58325,$C5F84BD7F0919F9F
            Data.q $33057B9E36DCE9B4,$8CF66DA163446AF9,$923D9F55E2719791,$4DF93DB1908601F7,$2007DE556703200C
            Data.q $9345A6F4AA1A2222,$1D5DF6E96FBE3E56,$1842811D1F0ABBD3,$08BA0BC215D3042A,$8EFEE30DD68CDA1F
            Data.q $61EAA4EA4947C2AE,$F306D88436E74DD9,$C990E55C4095EAE4,$C421C743BFA48FBE,$0E3CFDBC44F73A69
            Data.q $E9B6597F013EFE2B,$BCB1D7305BBB193C,$9C55DF2359BCC082,$BB3E3BE8EE7F2B71,$887F47A40553E9EA
            Data.q $22222007DE73647A,$5E1F93C596F48A1A,$8F531D3DCEE977B3,$09D503E1C4663E19,$D9202BCAB874361F
            Data.q $140A4F0FBED957A9,$90BE9A42E74D3754,$4FD79E3C6F78A240,$3202A61F9DD3CE1B,$E3B9CD356FC8C677
            Data.q $667F1543F47A35E7,$407BCA33151E9EAB,$F227AB8641C00CC6,$D7A350D11111003E,$EDEF7B63F0FC9A2F
            Data.q $4EC3E1EFB0B8F871,$87EA99587C2EEABA,$7DF6E1F0D2AE53B4,$8C5E74D3BEFE22F8,$E9B48EF3A69922AB
            Data.q $C99015B4192CE8BC,$8F86C6F47EFC4713,$B6006D5D0FE1ECD7,$840147A221887DE5,$2007DE64F3819015
            Data.q $60BE3E8E4A1A2222,$13DAEE97FB0DF2CA,$3E571998F866394C,$E3ABB51923E1F774,$B655A446C26173E6
            Data.q $B95F278AB75EDCD9,$64ABD5EED7F6E68D,$C98365DC3E1C47DF,$78248FBEE3F09487,$3CBBB8A0547FC240
            Data.q $D8C082BCB057A47C,$77FCD71D27CDFCE3,$EF53C1F52A4B55E2,$9EF8C356C127066D,$7003F1C80AF2A6FC
            Data.q $A8888884018AE190,$C4F63D262BE6F44A,$1F08BD598F859EA1,$C71F09BAAF93A742,$7AF761F0980E70DA
            Data.q $4E9E8365DC3EFBB8,$42784873A69922AB,$62EC84FF84B4F8A2,$9B6BC234DCF987CF,$DEC96F3142C46D36
            Data.q $55B73F8061FF3D5A,$83801E8D60AE9F47,$55111111E52C470C,$8EEB23D268B4DE89,$63E1D8E3BBB9DD2C
            Data.q $A747C2EF7E7842B6,$093A122445718305,$EFA6EF3C6A74951F,$1D5D98ED06CBB7C3,$E0213DCE9BC79F37
            Data.q $C51DAB4A1FF011EF,$811015A55CAE4CA2,$776986D6F51CCF17,$536F2185BFEDADAE,$C7AD003C221807DE
            Data.q $D14C181901EC4DFA,$3E5C37A055444444,$ABBEDEEE07F591F1,$E7842B66AED3D8FD,$AA95BB31D87C3DF5
            Data.q $378E8426ED26151E,$ED06CBB0FBE8579C,$2CC28BCE9B4ADDD8,$E3F4252F17DE2C19,$DD8F157A99C147CA
            Data.q $DCE61A97D47D339D,$46C2B0FE9E6D5B7A,$200F289E6639EAF4,$4444200C1D5BC31C,$CAFC7CBC9FA4FD44
            Data.q $0923E7B777776D8D,$F08BA08F873B731F,$947826007C30F611,$7C91FAA644290F87,$BB87DF6913DAFF1D
            Data.q $53C55F73A6D2B06C,$6D3F7CAF9337EEAF,$93F3B6EC3F7BB738,$F1DC77D1DBF4D45F,$40182E186BFF1AB9
            Data.q $AAB0578401D7A7AA,$544444400FBCE9E3,$3BAD56E3C5A6F4CF,$CC7C36EF386ED4BA,$611F0A754738E853
            Data.q $B24A3E1654A3E117,$6C365C3C14A8F873,$41B2C91F7DF75414,$ECFFFDDF8F1E74DB,$FBEF7D571D9479BD
            Data.q $2D927AB7576ABBDB,$26B525B24B2C96CB,$70108710E0B8715B,$04340D648D8C071C,$325C0C9AE4842108
            Data.q $797970977DC900BD,$817979B92F21B924,$36A42C1084580424,$49078081BDC81C53,$DD0D1B3C968F3CD6
            Data.q $DECEAAA7DDD5AB52,$3A9D576ABBDA8FEF,$59D6B3F7E3D39F63,$EE5567D5DF25A7DD,$DCED660EFBF2FA5A
            Data.q $3A40DE461EC48C65,$CE8511F3B35C2E70,$E3B0BC5C9DE0DFE7,$F8C1D7C7730FEC9D,$554419817FB26179
            Data.q $D930B86B560B013D,$515D3000000000BF,$BFF8393C1FE6FAA7,$29207EEDE8E1FC5F,$F573953F1F11562C
            Data.q $8515E6C3647C43A8,$63C47DC95478B987,$9EAF48F41B1E9483,$2F14E24E19F9D09B,$D465D72B9630F9D9
            Data.q $10F5D25F2D0EE9D9,$ECC21EC26875B15B,$FBA8935DC41122E3,$71B6645FA2D1D202,$60000000017FB27E
            Data.q $F2783BCDF48EA23A,$469DD8F2FF3DBFF2,$21BC11F1797EF87C,$423E2C354908F9DA,$D6D91F12992428A6
            Data.q $E0FB932B76D2A62B,$37049C5087DCA944,$647A53C3E6491F7B,$5B7624605F9D0ED0,$609EE7424AC10F97
            Data.q $6F56DBBBF76F4774,$8920F6640F293E3B,$7A10EEA1CD62AD08,$FEC9C5C4D400FFD5,$3A86E98000000005
            Data.q $F6FF2BB9E873D7D3,$D63E2AAAAFA3CBFC,$25811F13EAA1F16A,$A95572CB2BA6E23E,$6AC61F724A88976E
            Data.q $5FB1A0D8F61F7265,$E7434AABB9D09979,$75A32E173A1A5BAE,$6FFEDAFB58FBAF2B,$6FDFE0DD9843D84E
            Data.q $8443B217F6ABC1CD,$00002FF64D8C39A0,$9EBE99D4274C0000,$1A5EE7EFFF2E27C3,$25AB1F115610757D
            Data.q $F0F88DCE0694F705,$CDF0F894AA50A4B9,$AA54289C524943E5,$1FAEA4784E5572C4,$1F338AAF6D73B5D9
            Data.q $DCE8761F1195DB56,$F2C224E0FF887FEC,$63B8B65A72E173A1,$1F027DFFFD9DD77B,$ED0E6B7EFF076CC3
            Data.q $D202E0805642FED5,$00000017FB26461C,$8E7A5BD4EA0BA600,$DE8F2F73F6FA1A9E,$563E2B28D8918415
            Data.q $232047C5647CEE96,$A3E2A560F8AE554B,$D6B3CE564B07CEEC,$6E6426387DCAC72B,$D09B9D2C960AF155
            Data.q $D9779197BBC15C79,$F06E9BF3A1A51F16,$710ADEF3BD7CDF0E,$9817FB27867CD014,$68160B5920155421
            Data.q $00000002FF64E10E,$B1C753781D4074C0,$B776BC5EE75BF273,$420A2A1047C5A41F,$BA5BD1F122A04149
            Data.q $0D97AD21F12CDE70,$C67372BD6B24DAD3,$89773A1587DCE306,$F3677938C173A1C5,$5D1FAE88F891E743
            Data.q $626DB6B7A5E5CE1D,$082C4F107F8EBE6B,$805B2C16AA8737A1,$0003C2703CDE8020,$38EFAF76A0AA0000
            Data.q $AF6BB9F6763F9E7E,$104148BF051F13CF,$EDA651F16B97F57D,$AC883A2791F151AA,$DAEE57657ACB7375
            Data.q $06C6722836330FB9,$12300C48C673C5E3,$89156ECB7355ACBB,$D795F6F2E09E4E0F,$98A5D8EBF7BDA3BD
            Data.q $7F6A9CC39AF82078,$20101F183DF32DC1,$F5EED40540000000,$B9E678DF04AF271D,$0A4AB71F155437E1
            Data.q $451F131ACF91567E,$89648363C5152452,$32BD6D886B592C8F,$36468461F726BB95,$8C9EFE6787046E74
            Data.q $E8CB85CE96D51EF2,$DB76BEDC3F73558E,$0170528011E02677,$690171D085750E69,$650000000160B01E
            Data.q $A095D4FDA7BDDF50,$11F16D7BE1B9F4FF,$8BB5FDC7C472AE59,$2507C4A562B7408F,$71155F455CB6C3E2
            Data.q $D7D20FD7D22D274A,$8773A158E1DF248E,$E94F0FB944844B31,$9D2F48F7421D0F9D,$434A3A24479CA217
            Data.q $23FDD23E7497CBE7,$6058034FB1367FFD,$D0B614D55439A567,$0E8420CD4056AAAF,$79F48EA0E4000000
            Data.q $DF86E753FE9CD867,$1F12DCE8511F1594,$08F8BF1E6F05254B,$92287AC923E2C649,$7AD6479C9B9F0E94
            Data.q $955D06C661F72E55,$2B195FB2CA7A0D8C,$11DAE485DE4661D6,$0B83B6F3A153CF07,$006CC1CE843EF65D
            Data.q $084C000000002BB6,$ADB5E2F6779F48EA,$B8F8AABFBD5CCE27,$CA87C5F8F83E5F45,$C7AE0F23C2B2AE58
            Data.q $0D8C991C3EE52B02,$1684AF58D06C7A7A,$C24E61C49C8BDE25,$E97CE96F3CF07163,$0FFC75FBD616DEAD
            Data.q $0000020100566098,$CFE3E91EA3968000,$1B43D3B1E2FB5E0D,$FC3E22550208F88C,$F360F05248BF9240
            Data.q $5C3F5F61E12547C5,$61F7255387DCA9E2,$AE24E3084BE3CE87,$CE3773A1264F1232,$23F6F7B79D2E947A
            Data.q $0005E1A80D660E74,$E2F444514B400000,$F6F4313E1ECF9192,$811B112A86149420,$0A458585F7E882BE
            Data.q $23E29D411F169ADE,$5A9589C1F166AA64,$E23EF7B0FB9D28AF,$EB9E0E306C6B41C1,$8F39465CE854C1B1
            Data.q $B2BEDC80B9AEED6C,$2036CC1CE963BFE7,$1432D00000000040,$783EBFC1E3B2BD11,$3C2C47AB9A2FCAEC
            Data.q $6E15240FCAF9A482,$0EB5F3023E5C962A,$A5E7826BB35A51F1,$D7788FB9729B0FB9,$F3A8363D20FB9B23
            Data.q $89393B12718BF11E,$DA93CED66E7424E1,$9ED7F8EE2EB74E5D,$300041E427C7DEE3,$000000000B058085
            Data.q $77DA9FF5EEE2E32D,$EC3E2D20FCD7F070,$A45F9854903F5DDA,$A8F8BE6DDF22BD60,$883EE497DFA1FAF9
            Data.q $1B1987DC99E68B45,$38938821F9B258F4,$B6B2BC6EDE7BC8C9,$7389D70DC7E6F43F,$2B6EBD9BBC76E78B
            Data.q $00040203ACC15FAA,$F5DED2E12D000000,$C4F3B7F07FB9DF1F,$4946E08F8890A147,$11F119047C4486C1
            Data.q $176D5508F8975530,$30FB9B3772B6430F,$FAE31E836379BB75,$C48CF3DDD405121A,$76ABB084AEDB1E5E
            Data.q $E5DE919DDA73AFA3,$7EAD03ADCAD89BDD,$00004020454C0006,$F8DBEF2E74D00000,$F16CDFF8BBEE4F7B
            Data.q $3E2D4208F8898411,$E1F12997AC2A49E6,$788F89359287C567,$7EBEC3955CB2D070,$AB36459C552C8A70
            Data.q $333773814507DC92,$C9C48F183E5F1836,$42B1C24E71EF2718,$7EBEAE572D8F0EE7,$6DCADEEBFDD95BAC
            Data.q $40E5300051E827FB,$E54D000000000406,$8BBEE4F1BF8DA1CA,$82261E703A07E27F,$2B98292F828F88C3
            Data.q $47C59517C92F5FC9,$7B61F17CA0F8AB50,$F1695EB191E1229C,$456EDC47DCD2C8E1,$1E75CE5788FB953C
            Data.q $5587EBAC0C1B1E24,$A2BD5F3A14442BBB,$13F3F478EE73D3FB,$00804072980038F8,$BA3B5C69A0000000
            Data.q $8CAFF173DA9E97F1,$2DD1F129E703B0F8,$C8B1976FC920DFC9,$A2F247C438C78588,$CA298AF5BB0E55F8
            Data.q $258E19123CB87DCD,$6258ACB3C3D64C4A,$5610F99D206F231F,$CE60B45A70EBAEED,$0F21343EDADA1BAE
            Data.q $0000582C0C298002,$FE36C7230A680000,$57DF3BFA5D77F7DC,$8741582CB023E225,$A5E3257C921D1F16
            Data.q $441F10E3AFE940F3,$F5AE595FC783A2A5,$2B0FB9B2B2EE54CA,$28543D5D06C7A1F3,$1A2271271CEF2718
            Data.q $E8F3A5A376ABB41B,$A8B65C5EE5D5D1F2,$47C09FD5B95B0B7D,$000010170494C002,$1BCDD1C29B8C0000
            Data.q $E482FC97D2EBBFBF,$52508F57D023C225,$6AEFC9243FE493C1,$F4C4E0F174A8F8BE,$9AEE5494387C48D7
            Data.q $2382447DCAD70FBD,$A1F726566D8C1B19,$A6BB95459062586D,$5C3E233DCE074AE5,$1F77456EB970424E
            Data.q $001C7A0985FDB95B,$000000010170694C,$FFFEF1B13B18B8C0,$B7C3E2792BE179D8,$89B53D1F2FAB87C5
            Data.q $094C51F15CA9228F,$967BEA783CFBE48E,$B92783EE4D75DCAA,$C2341B1987C5A10F,$E9506C66BBB533C4
            Data.q $E88C22A1681FC1B1,$558EE40E51E743B0,$F5AF7FB66B161FDD,$00080401E980024F,$E6F8F4661A000000
            Data.q $98D8DB7175DF1E7B,$788F8898558B62F4,$7C44FAE3E2D1C3F3,$7CC95F0F8A2AA484,$373C1D87C5F2A1F1
            Data.q $95D95EB1BDF30F17,$43EE74970FB979BB,$924985A398DBEF46,$4624E09F06C788FB,$3A5A377AA48FBDED
            Data.q $7FBB57E7496CB4E7,$80050FA1367F6BE4,$00000000582C0E29,$DC9FBBA6D8E08868,$D30EC563A35BE97D
            Data.q $6C4883F7375D9572,$47C5A437F915EB04,$F33C0C3E225B1541,$E23EE56572DA673D,$E80B30FB93960FBD
            Data.q $18F773C135DDA932,$7EC93CD84987EF23,$DE79A6E8C387EBE8,$BF2563EFE3AF9BF1,$000010081BB30019
            Data.q $ABE37A7F8DD40000,$B0D191EDF83FDF1F,$401D81497C362523,$8C6FF22AB7829267,$A6423E2C55C847C4
            Data.q $AF7306C6F23E2DC6,$41B192AE5DCA991F,$5997E23EE6CAB763,$8B9CFEE0D8D65739,$DD0EE1D1D8363587
            Data.q $E1F5F35B136BB4B6,$C1607D4C00327D89,$CE145D4000000002,$3DBF97D3C76EB43C,$828A1F33A4F41C3C
            Data.q $494422462FC15150,$566C8C2FE4501E0A,$D4C147C4667E8F21,$B0F37D423E21D6EE,$72BD6A54E0F23F37
            Data.q $109727970FB9C789,$0D8CC3C258EBB353,$8160D8CC3E5F4CBA,$AEE603A12704F793,$647E8CF798EBB95D
            Data.q $7C76DEADB5F7DCE5,$10080DD300079E22,$E9D8CCD400000000,$E5763D0FF77BBD0D,$ED78A878C93F306A
            Data.q $C7C48C58428F88DC,$08F894C9905C7A2D,$A22B960D611F14EA,$F7295BB95247EBBC,$B9479D1871E80261
            Data.q $71E24E273E5ECF0F,$D8F4DC405D683633,$76B6DA7FDD159AE0,$27A6000D3FD6F6DB,$26A00000000160B0
            Data.q $3C8C8F8745BE89D4,$B5D1841C58306976,$E80288F99C550823,$FC8A4DE0A4A2828A,$47C58C9011F169A5
            Data.q $8A1F118455DB21A1,$2A4A20FD731B2F25,$D92416843EE52B77,$0F07078DDDA987DC,$E9661F33A62EF233
            Data.q $C773725A707DCA3C,$F613A3EDAA7F5FBF,$000202E086980050,$E69B63A8AA800000,$8C2E57EDF83D381D
            Data.q $50F385AC3E6696F5,$C54BCBF92467E152,$22DD6AE8745A4F87,$C7D30745B0F97E35,$19D2BD6D91E2F890
            Data.q $223EE562112D2E10,$7CBA2C787DCE91F1,$0E24E65EF1117D08,$9D0A23D5F6836347,$74B4BEEDDB9B3F47
            Data.q $34AD6D4FD83BC761,$00040207ACC00EC0,$7437C75115000000,$8F2F0BD8FC37391D,$BC4785A847C5B3AD
            Data.q $5FC928DFF24811F5,$5A580A4A408F8899,$3C8F8AB5F7D6047C,$3C231C3E230E51E1,$A0D8CCF0FB95D514
            Data.q $CEAEE551635C7EB9,$06C648F8D99E787C,$63EEEF2ED70F04DB,$6000C3E96C5EB72B,$8000000002010006
            Data.q $EB3C4EF16F53A8B2,$841B5F4717D9ED7F,$F17D423C2462C292,$BB7F925EBE0E8D48,$23283772BA1DF24C
            Data.q $47C495576D1AC23E,$ABD6C47DC923F5FE,$3A4BA0D8F61F723A,$0D8CC3F5F1645E74,$7A6B1DD1970FD9C6
            Data.q $1E82727F6CD62C3E,$000040641AD3000B,$9F8FA47A8B900000,$DEF876799EB6917D,$E2C79BAF4FD05078
            Data.q $1F2FA23FF925C7E3,$F152ABD6C480BACA,$51F2F5AABB695411,$8AE58D772AB2BD62,$23183EB788FB91D5
            Data.q $7906C7B418918FB1,$E92DB720AE6BB55C,$227CFF478EF3B47C,$001008013300099E,$85E888A094000000
            Data.q $0DD5CCEC70BED745,$55DB13CF8511F159,$F88E6EAFF92547E1,$7F45521F15954908,$C3EF66BB95791CA7
            Data.q $DCFCC1B1A23EE4CB,$2712702F7888B987,$5FB63CE74261E16C,$738DD166789D7F5D,$02076A0041B18BDE
            Data.q $70FC250000000004,$9FA189E0EAFF5BE7,$C5F82ABD6987C5B7,$6913FF9246B1F324,$08F894AAECD491F1
            Data.q $C34CAEDB61F17555,$6329CC0711E13955,$641F7262033A62BD,$C3E2D5DCB0743EE5,$91E2BC6E2B4D9155
            Data.q $8B92A78919571110,$B5183EE518363D87,$B63EAEB2E56C7C79,$A6001E3F04D0EB62,$4800000000201035
            Data.q $723DEC4F86EF6971,$3E37A852508237F9,$03EF462FC179BACC,$12AB4FC14932FE49,$F2A54A0522A051F1
            Data.q $7381AD48848AA11F,$5B48FD924791EAFB,$E1F7265E5DCAECAF,$CC787DCA2821D168,$FBC9C8A24E487DCA
            Data.q $738F0784890F9441,$D1875CB1D913AE1F,$7DB95BC87DD7D5BA,$10106600143C84EF,$DA19880000000020
            Data.q $AFF81FEE77B7E1BF,$6CFCD772A4BCD966,$314DB23250FADEB1,$9147848F211F1295,$9C1F14E3F87C4A54
            Data.q $5772B8D7CD0687A5,$694F0FBDD6A44245,$9A78918CB97E95FB,$0AFA583EE76AB893,$763FD76B715A30E2
            Data.q $0091E0276FFDB1DE,$000000010080E330,$97E9B23B5D111100,$987C5B29F03FDC9E,$54DC2ABC6ADF0F8D
            Data.q $E4A7C385D12DE0A4,$64C8149721576C65,$E57ACF23E2D9A3E3,$12323918CB870BE8,$D3C3EE4CAAF5B11A
            Data.q $DE4E32E202E6578D,$D4C3EE74B9DE4E59,$8EDAF38DC82B9AEF,$00183D84F0F4E02E,$00000005E1A81866
            Data.q $5DDDFCD96D8E1500,$B2BB6455F7CEFFE7,$493CD5E3560A3E37,$28F8A94EF9155BC1,$CC201AC08F8B1928
            Data.q $547C5F2AE9A88F8A,$9538AF5AF21B990A,$A1A2875D9A987DEE,$4BE23EB661F73B41,$E95D89190624E308
            Data.q $8EABE6987AB9878B,$D85B39D2DB7C3E76,$6600143F9691FEAA,$2CC0000000201028,$E9E3FEFBA6E8EC67
            Data.q $572CA7920BF65FF3,$E491EABC6E3762BA,$1547AB9917C9283F,$8F88DCF968CA11F1,$9B196034C3E20D62
            Data.q $7930EB84FA598195,$E2FA456ED30FB9CD,$33A60FB9C47DED61,$7DBF3C5987DC991F,$3E3F6D56DB87DCD5
            Data.q $582C0A998005CF11,$B53FC62CC0000000,$A15AFA5EF627EEF9,$61F1681572DB3D20,$255BFE490E823EF6
            Data.q $DD9AAC90607A1DF9,$808F8B152451F11C,$25967FD487C59AC9,$C378970FD7D0F6DE,$718F0FB9D2C10FB9
            Data.q $60FB935189383B12,$EAD1870FD935CBF1,$3FFB76B39E9FDD15,$010206600203E84D,$670A52CC00000002
            Data.q $8F6F81EEC4F75A1E,$9D20DDBAE23B168C,$47C5A105494208F7,$3011F16962BB6EB7,$07CBA326023E2255
            Data.q $C98791F146A342D7,$88FB94ADDCAB947E,$739D0A23EE7E47C4,$7DCD2C5EF2314F72,$F6FCE16BD1576D44
            Data.q $07909A1F077437BD,$00000402070CC003,$BBD0DE9D8C859800,$3D070F0EEF95CF6B,$B5C57ED5A1574D25
            Data.q $F119F87C44FAEAED,$E225520E09192BE1,$1D12D160B0D15423,$EED4957EDB0F8AB5,$47DEF14532EE5696
            Data.q $DD00711F7BD0FB9C,$5C48CE742650FADE,$7B595D34E4F62464,$BA8B15E5F8739D1F,$68F013F98F95B0B6
            Data.q $0000008040F19800,$C3C2F374750CB300,$4FCE1432BB1E4647,$8C5F828FBD93CD96,$BFC8A83C149287C4
            Data.q $987848A9211F1131,$32F3F592149287CB,$960C0F1E70BB23E2,$CAF58CDD8A995CB3,$7AC4A1CAF58C3EE4
            Data.q $A65C3EE4C3EF6D55,$049C13DE4E7C3EF7,$304F2BE6987DCD2F,$5B35B2F7DCD57DBA,$0306600243E84DCF
            Data.q $D422CC0000000201,$EDFE8767039EBE99,$B6D87C46BD630B95,$A8CA2FC8A20328AB,$8891E0F9DEA1776A
            Data.q $47C5AE74B462A828,$CA3E5D755110B640,$DEF48FCDE90CAE59,$CE23EF746DDCA987,$A9E09E1F73A58C7D
            Data.q $BEDA7FDDE5EAC80B,$98004CF95BD7FB66,$B30000000080406D,$57B389C77D7BB504,$EDA95D6C79785FFB
            Data.q $200000A1BC73D8CA,$0ABB6A5441444900,$D9D2B76D12E0C8F5,$11957EC60A3E230E,$E5DCA3E2B992811F
            Data.q $C55EB590CBF520C3,$87F6F4CBB9532BB6,$DAFA387848F48134,$C538938821F72D51,$B9C583EF6F297BC8
            Data.q $97F5F8F39E6E5B8F,$B3000E9E6260FE87,$B300000002F0D407,$FC3C3B3F1F48F500,$92841BDF0ECF33E5
            Data.q $F8715E8C30A4A2C2,$5FC92D3FF95F375C,$41564D45011F169E,$B396FBF0AC87C513,$BA15D72EBB95D95E
            Data.q $83EE4C8E0911F73A,$190777581D0FB959,$D465C21F73E57D89,$1DF746EDBF9EE5DD,$003C7809C2F7CD6C
            Data.q $0000000101702ACC,$F2325A5E888A3866,$AEDB886EAE676399,$D61B623C5CCAE5B4,$4811F1126BF924EB
            Data.q $F162A405248AF1AB,$6ABB6F96451DB261,$A53DFC472B987C44,$DED1047DCEE357AD,$2E78BB23EE494B87
            Data.q $5B277DCEF4779704,$980074FF5A97F5F3,$330000000080407D,$B1C0F27FD77B4B9C,$0F79C79BAF1CBF2B
            Data.q $246BFE4902AED895,$F5A4C95C356A3FF9,$157C3E2D451F16CA,$FEC8F8B71C901F7D,$1907CBE87EBA2483
            Data.q $6AB96EB8315D11A1,$9D23EF6F2BB1F728,$EAC5C7EE72B758FB,$B3000A9F6B7BFEAF,$0660000000100817
            Data.q $FF6BB2FFC6C0E573,$6574D2557B2247E0,$6BC7ABE99FA2AEDA,$E5EC90175943E5F5,$D73061F14CDF7F43
            Data.q $4F5BB9530FB96A8F,$DE4659C49C65C3EE,$F9CD164B1F7395F3,$8F0135FFEEE3AEF7,$000020320B598006
            Data.q $77A6C8F4650CC000,$A3E234BF85D76F7D,$9265DDCAE81E7824,$1EF248F894AA3782,$1F16A11F12CAF1BA
            Data.q $794685A922BE69A1,$5A97DF64785951F1,$EB1874BE882BE2AF,$FB972C1E1A9E2095,$3EE72ABBB9199710
            Data.q $BFB5E74BF39D3A7A,$00175FA56B7EBD9B,$0000000101704E30,$83FFDE3627632066,$6D428A04173F173D
            Data.q $BF9240FCB05ACAB5,$08F8DE2AB3F05240,$2A940A45574DD299,$8BD423FF7A8482B9,$AA415CC3424592E7
            Data.q $DABF8F2EF56C8F89,$B715EB187C448FD7,$83AE2953B185772A,$71EF27211F7255E8,$DE5CB87DC855824E
            Data.q $BFB7DBB0F7BAFABE,$040BD980084F3132,$4FF0C33000000008,$8DB606BBE3ED796E,$152408F5752F498D
            Data.q $782927983CE8490A,$D7385AC9CED68AAB,$66CB2A2A4B908F97,$29D7A209A11F1195,$CB95EB6548454A3E
            Data.q $5E4AE1F73F323918,$3956B8939BB1F73D,$958A9FCF4576B1F7,$6600253DC4CEFD5F,$0CC000000020102F
            Data.q $2FFB9DBAD37A70A2,$3D5F61D8AC746B7D,$E490EFBF1BB15D02,$A0A3E2A517C9283F,$6CB45520525C8524
            Data.q $3728F89E79F092AE,$5E3CED7647C46832,$99772AE5EEFCCF39,$72CA6EAE1F73BAA2,$58FB9CAB9DE4659F
            Data.q $EC094F73E3FB737C,$000203204130007D,$8BCDA9D410CC0000,$6095F2EC7C181C77,$92847CEF11EF367E
            Data.q $43BF2490FF92420A,$30F88CAB36D95DB7,$E239E783A645201B,$44A8F89CA302D423,$EE55E486B995EB39
            Data.q $316034CA5C3EE5E6,$E42AAF5A8B2AE24E,$F66F5B819C3B3A3E,$26000FB90A7EC9DE,$1980000000405C0A
            Data.q $A189DF7F37D53A80,$9CAE97160C1A5F6F,$3A3D1F2FA674015B,$67E49287EBACCE70,$7C4B347CEF5147C4
            Data.q $72B655EB3C8FD7D8,$FB972ABD630F88D7,$18A3EE74A10F5730,$275C3EE495087DED,$F7EEDEF6E8C1F7BB
            Data.q $0A4F7130BDAFDEB2,$4C00000002010000,$5CCE471DF5EED473,$EC9EDD8CAF4BD6FE,$8918BF05BB95247B
            Data.q $4A551BC23E651510,$F88954425CCA047C,$90F894AA50A49808,$AEC8F8FFD87CBCE3,$30DD731D772B679D
            Data.q $272F63EE63560F97,$F73A44F0FB9D3571,$EDAFB79FF74566B1,$0720000D1F0B66FF,$A31A600000001008
            Data.q $67FE8287A779F48E,$BCC3E5E96D7D1C5F,$BA85FC8A7DD60B74,$BBB5D02202479766,$B2C36A290FBE8B01
            Data.q $0D847C4A64C047C5,$4247DF30FD730F8A,$1F7261E2E61B1223,$B2651CAB58D772A6,$50F79D2087DCE91F
            Data.q $533BC8C0BC7DC92C,$AEBB3982F371F739,$000213FD6D1F6D13,$9800000004064164,$73E4706E7A2228A6
            Data.q $85240FC9BF0ECF27,$95D34CBD18614945,$97F24B4FFEE7C3AF,$45505492BE830327,$2212C08F8911F7BD
            Data.q $C87C5B150B43E5F1,$DAABD679441F2F06,$F72647ABE92E1F72,$957141C1E87E6F11,$0FB9F9E1C9C1D891
            Data.q $BE5E5F8739D465D7,$B5BF56CD6C1DF3A0,$00202E079000084F,$F5DED2E534C00000,$FBB2BBCAF2723C9F
            Data.q $FF24BE2012DF051E,$D4823E25B9D2F4C7,$F112A4847C5A60D8,$8E611F12CAE5B4A1,$4457ADB2AE9BB0F8
            Data.q $2B9AEE55E430C889,$87DCD9BB95F95708,$4E49EF27243EE6C8,$275C3EE491E11A42,$67EF75E563B8FFD9
            Data.q $000507B09B9EB66B,$4C00000002010148,$FB5D81F8DA1EAE43,$C3DE4DCE56623F07,$29DC7CBEBE0AADD8
            Data.q $6C48C87ACACBBFC9,$A047C44AA41F7BC4,$2AF3E1D2423E2C64,$B7BE6E782950C3E2,$D87DC9AEE57657AD
            Data.q $0FF94643C5F1BB95,$BE878BA2C95C3A23,$B8919FBB918CB88A,$9735C3F6491F726C,$5FFFDD65AAD18710
            Data.q $0084FF5BDB6DDADB,$000000010080E500,$E3FB7A1F472319A6,$25E683A875FD2E7B,$249963E245408FD9
            Data.q $480B92A1F2FA75FF,$1BA56CD3451F1190,$9B0F57791F111AAF,$57AC61F72B2BD6AA,$4B0D9163C3EE42A2
            Data.q $C712732F789448A8,$71F738F0421F734B,$7FF1E86FFB6D0DD3,$103CA000119E226B,$F46234C000000020
            Data.q $C5F03DDF1F7BA6F8,$0B2D0587B7DC97C0,$DE0A4B17F2481F96,$195BB22AF9573514,$BEF7F43E5F6F95CB
            Data.q $F8A75E7ABC48848A,$1A8FD75AEDD492C8,$491C2FA18163772B,$5DFAE9E1F9BD3D00,$C70E09193C48C231
            Data.q $4BC3E769CC7DCFC9,$7218F95B0779CD17,$00002010324C001F,$75A1E670A134C000,$97A4142FE81DED4F
            Data.q $29207EE72B587ABA,$766B8ABF705241B8,$522A054927C8A643,$0F88CB08F88954A0,$B5CC591F15EA3223
            Data.q $A92C65D772BF2883,$0C0C951C3EE4CDDC,$C9545444237381C6,$21E1231449C53DEB,$EB87DC922795D374
            Data.q $D7DB87DCD563BA30,$D40001C3D96C9FF6,$0D3000000008040C,$E87FBBDE2F36A750,$43E5D49EC2D76BB1
            Data.q $F9247A0F3C130F8B,$E71830326EF925EB,$23E233CE568A943D,$924908F8ACD7D160,$C61B13947C5BAA24
            Data.q $B9528A65DCAD957A,$039D87C488ED730F,$918C758EC61FAEB1,$C3F77A787DC9217B,$73F7F5D65AAC80BE
            Data.q $004E7889A7FF6ED6,$000000008040EA80,$C9C0E7AFA6751C53,$B73659B9CACCC7A1,$F92420A928411FF3
            Data.q $FA56CD59B7E4956F,$3259321F12325055,$D89192B76447C5B7,$DAA92A99147C44A0,$AAF5BCB76EA5AA25
            Data.q $D3C415DCA991F724,$93C53DCE04957401,$CD84D0712700C7DC,$4DD183EE51E72BD3,$15A87D13E7477837
            Data.q $0101D818D00005CF,$9F48EA30A6000000,$1E5E17FED5ECE277,$83D5BB687C5E575B,$ED37395A996EFC92
            Data.q $D16F0D56047C4657,$20AF8A22914C1F16,$F1BA55DB16A3E279,$EE576B87C46F7A2A,$5CD70E97D0FB9D2A
            Data.q $B5D6123397271435,$36FFEA0D0D6E7043,$6EBD4C24E09E2464,$7B6975B919C3EE6E,$243E9691B5F95B1F
            Data.q $00000202E05D4000,$6799E0D0CC514C00,$5C98611EF3B5EF87,$BC1494505150823D,$408F894AA3785159
            Data.q $C4B7C3E2B95317E9,$FD487C43A9157C47,$EBB950A8F39252CA,$E5161C8C457ACB28,$3D5D1625C3EE4C3A
            Data.q $5D8BA80E9E281228,$FBD923EE74D1DC9C,$6C1FDD55BAC84488,$004E7EADA3B5F95B,$000000010080FA80
            Data.q $E1D4FFAF771728A6,$87B7395D95DE5713,$FC928DE152408306,$5D03CB97AE703A25,$BCD178C87BEC9BBB
            Data.q $1647C538E0D0F4C8,$C6EE55354441FAFB,$DCF166BB950A8E57,$B3E7BC8CB3C4B3D8,$969CB84405C9BB95
            Data.q $FA3FB739E7FCE92F,$81C68000367AAD0F,$0320A60000000100,$7F0707D3C8FA1F7B,$7FF2481079CAD2BB
            Data.q $62A82F3959905242,$18343D87C5ABB954,$23E2D886BEA14930,$43FEC8F8875E68B5,$726BB952D476BEC2
            Data.q $D9D87DCED772A61F,$257772330C84588F,$576DC583E6518323,$C2DCEF1EFAE8C3AE,$000088FC5B57F736
            Data.q $4C0000000201020D,$03CED77A6C8F4631,$1A1E3CE56E593E97,$7395D2AAFF9253BC,$CBE9211F1591F7B3
            Data.q $BD986C461F2E4F07,$572CE51F1795228F,$96AAF59E7980E944,$F728A08745A15DCA,$24E4848C50878461
            Data.q $9AE25AE8C9EF2724,$1059D30E2111B9B0,$A7FD9BBF76F5572E,$340002A3C04F2F47,$8530000000080400
            Data.q $B9EC1FDEE9BE3D18,$61C11A145020B9F8,$922FC1514082415D,$95A6AA93F0524CBF,$7395E325023E2373
            Data.q $D51CA3E21D615FA9,$5D8A93772A9557AC,$726570E8B1630E4E,$B89188726AE610FD,$FDE89017B3772A6C
            Data.q $7D5FBD131F3D95BA,$200CD000074F35B2,$E142298000000040,$1FEC1BEC76EB43CC,$EB12142C1A1D2B1B
            Data.q $703AB3F05240BF95,$3479CAECC1B192AE,$F8B153228C09182E,$A75834334B9CAEC8,$CAAF5BCBEFA9E0F8
            Data.q $FB93370FB9DAEE55,$E7BB95C561B22C10,$9C0987DCD9238939,$BF7CE60B45F3E147,$008CF95BBFF8B8EB
            Data.q $000000BC3507E300,$C778BCDA9D4014C0,$FB1E838786C7C1FE,$1A3F05E72B5811EA,$7844F3E4501F0C1A
            Data.q $CADB56739592A484,$EC84F395E91F11B9,$5AB1CD7F1E1647EE,$8AAEBB9572FBF4A9,$65C3A232C2698684
            Data.q $8C63BCD533C3DE51,$2BB95B3CD84993C4,$6EDBE5CE1D9D465C,$BF4AD6C37B0F7CE9,$00080B800A600036
            Data.q $E3068764C9300000,$325B418343532F97,$91F17CF3959E3834,$592A1A0C8DAA3D5C,$82BB9572F3B5ECAF
            Data.q $71622BB955880BEB,$F09383BB938BF4C2,$75E8DDCA99E0F08D,$9F5B15B3F7DCEF47,$0800B40001A3F26B
            Data.q $1BC9126000000010,$918B1E7824C20C1A,$59541E72BDA0D0CC,$9562C61F11280F39,$427DFC5603711F15
            Data.q $72A5AABD62D49056,$6953CAF5891F1237,$7BC8C53893882211,$017D87EC923EE4C5,$DDADB7DFD75B7959
            Data.q $1CD0000ACFD5BDB6,$892600000002C160,$068661F2E6834372,$41A1994B7829257D,$E57A97395957E492
            Data.q $0F89CA40F78A2A5C,$372BD679E78B6A9B,$C235DCA86A9772AF,$24E65DE21338F143,$923EE49E6C38F1F6
            Data.q $49F3E3BDEBFCC82B,$5CD00009CF95A87D,$8926000000010170,$D0686F327FD77B4B,$229F7047E6CC3FE4
            Data.q $987C4B41A185717F,$3E5CB5E72B4AC1A1,$ACF79238230F89CA,$B9AA5E1A99907074,$22333ABA0D0CD772
            Data.q $E5C42E7427DC9C8A,$6A32EB87ABE938E4,$93BCE75BF2FEE36F,$00283E96918DF5DD,$0000000100815340
            Data.q $D7607E3687AB8126,$5430A4A1048FC1FE,$0D0F11F5B5AEC551,$A0D0F2BCBF924EBE,$3959EB06866E72BD
            Data.q $7ACF238230F976AF,$BD63372BD6B94445,$76BB95455E34C872,$62F33DCFD195C3EE,$F5C798624E5EC49C
            Data.q $721163C3AEE571BA,$DD1EAB7B0FDCEF47,$100D68000467AADF,$763304C000000020,$6BFA5EF62786F37C
            Data.q $79D2D11FB2683433,$A8F3926778343D31,$F116BCE56E583436,$9838372861F2ED51,$E7F88AEE55E55EB5
            Data.q $972C36258F100DE9,$D7499DE4625F7271,$4B4E10175B827AED,$FFDB759CCBFC7517,$201AD00009CF95A2
            Data.q $3FC4098000000040,$65F8BE9FC7AEE5BE,$75FF41A1B57920BF,$5BD2BD6E306864B2,$E47C478F9CACB51F
            Data.q $1AAE8B39CFCC3F5D,$C8ABD6255CE76B79,$D952AF58CDC9C55E,$53C48C2312C36D0F,$ED7ABB9532CE1C9C
            Data.q $F16578B75D7461DC,$0005B7E4AC7DEF02,$800000004020074C,$91CF78BCDA9D4209,$2A3C4762B1D1FE81
            Data.q $43D87C6CD0686158,$6D5BAB537395D983,$F5CCA20F97BC7CE5,$73B5E289CBB95323,$AC61C8C457AC6647
            Data.q $79392BB952557AC4,$E8DDCABCC512714F,$87BE76F4D68C10BD,$000263D16F9FF6F5,$60000000100818B4
            Data.q $C5FC07171F5B3002,$4B0830686B0F6DA9,$29068788F88D0687,$72B798343D7C442D,$F61F131A9147C46E
            Data.q $1C3EE6CABD6B23F5,$ED0647A15DCAA962,$B91827BB95AAF3B5,$F3DE5EAEEE572A17,$F3F56AFFFF556267
            Data.q $000010080EB40002,$D0491F5BD8C5A000,$477C928411F5BD3C,$AE5A6834347F7F92,$A697395A560D0DAA
            Data.q $9373FB23E29C776E,$565DCA9B9DAD48FB,$F34D772A4AAEE543,$72BE503893997795,$F7BEDF9C2D3875D7
            Data.q $00243C9683FBCF7A,$000000101D8184C0,$2280F1F5B5D485A0,$0D0EE47D6F197AFF,$A9539CAF11D2E4B2
            Data.q $5A8F8A947D6F48F8,$D64AAF5B2A89CED7,$19C12BF63108B5CE,$12C24E72108D6909,$9C12304FF7EA421E
            Data.q $3B476EE56CAB36C7,$DAD93BFB737C5E1F,$226000129FF37EAD,$21680000000405C1,$3EB79AA3FFACF697
            Data.q $F5BA5541A1D2CA16,$474BEA490C1A1D91,$4FAA210D7DB9CAE9,$EBB956AABD62D47C,$DD71BB95D89448A8
            Data.q $4B5C49C7DDDCA9AE,$72C76447DC93772A,$7DB07CF6F7B7461D,$C000263D16C9FF6D,$B400000002010204
            Data.q $C1F4F5DE9B23D188,$6EE5761F5B37DFC1,$B15D41A1DC8FADB9,$2A3150687B0F8B6B,$DE47C5554448343B
            Data.q $9772B655EB2547EE,$5EB1AEE54CAF58E7,$79190FEEE56CAFC5,$F2C7DCD9BB95D3A7,$F3FFA3B9CC8F9D25
            Data.q $1600C98000427FCD,$1E8C05A00000002C,$5CFC5D760FEF74DF,$35479E0928A1E9B4,$96F87D6C965F05BB
            Data.q $61F5BC54AF5A88C8,$DAB2EDD74C8B0686,$ECB547C54A890687,$2315957ACF3EF987,$B2D772BA5095EB59
            Data.q $AF2D743D674AB95E,$B9DDCAF558C49C47,$96E1EA1D8585E23D,$080B8384C000283D,$1E670A64D0000000
            Data.q $31B1FE81DED4F75A,$11F5B595C376F9E9,$489FFC92C5FC9204,$6F3C1260D0CC3EB6,$8E8B61F13560D0CE
            Data.q $7E8AAE57AD6D7DE8,$BB95B2F104AF5B6E,$9C9DDC9C55DD0876,$F7CEB6F772A55F84,$0C8FC5B975BF3BB2
            Data.q $0000008040813000,$EF78BCDA9D444D00,$627B0B5DAEC7A1FE,$3CFDF8AB762411D1,$4352AE428AFDC149
            Data.q $C8FADAC08FADD983,$23D60D0C35860D0E,$99BB95C55EB1EA3E,$0891415DCABCF3B5,$97BC8CB3DDCAECF1
            Data.q $E7FDD159AEEE572B,$0161ECB7BFFF4D62,$0000001008052600,$4E075D7D23A849A0,$376C583069763D0E
            Data.q $21DE70388FAD995E,$8F9D9377C8AF5829,$834330FADAD06878,$E04D068767A30EBE,$957EFCCCA0D0DCBC
            Data.q $9DAC2AAF5975E7C2,$5C425C947AEE55E7,$ACE8F624661DC8C6,$A1BA6F772B72C387,$F15B47C19D75E0ED
            Data.q $0008040B9300009C,$FC7D23D404D00000,$D8F2F0BD2FE185EC,$ADE3EB665E6824BA,$3A347D6DB5398292
            Data.q $95582DD87CEF6834,$AB0B9DAF657AC7A8,$0596F7A2435CD772,$4AEE76BD5DCAE94B,$5B6EE5497972BB6D
            Data.q $66EF39D6F5BB1B1B,$1033002EE5431F2B,$BC09A00000001008,$75733B1F5FD8EB72,$78B9BEBB75261043
            Data.q $C987D6E3590FAD98,$C1A19EB76EA4A876,$6D306C648683236A,$ACAF58979A0BCABD,$B6951C425F4773B5
            Data.q $3C2A1987FEF6B95E,$878B15EB1A0C48C2,$AADD6422C7875D07,$C56E1FF6F5B70F9E,$0020103E4C000273
            Data.q $E36FBCB938C00000,$CAF881F8323BEDEF,$48157AC6FA0C8D61,$C8A4847D6D18DE0A,$5F24940DDBAE3267
            Data.q $7D6CC8376EBB0F8B,$1F14564A860D0DE4,$724A2C7DF3108AB5,$95DB1B9DACF557AC,$01BC9C60FD7478A7
            Data.q $80BED772B670E24E,$DCE7DFE3B0BC5A70,$000263C16CFFE8FE,$800000004020114C,$0EA786F37C763071
            Data.q $B11F5B241FA4FA5C,$FE4931F8FADECAFD,$2A82A2921E6C249A,$A641A1A5611F5BC6,$C2D23E23C7068772
            Data.q $DAC945C4657ADF23,$591E0B9F987DCEB9,$AF8F38283E3D5CAC,$F12321578DD32E26,$BA561C7270E12724
            Data.q $960774EAEA30EE76,$0697EE561EF1D4DE,$000000402008CC00,$E3F57E6D4FF10680,$6A1E4BE072FC5F4F
            Data.q $E495AC1BB75791C1,$83EB6B4AEB5565DF,$7B0FADD2A0FAD855,$F50AA20F973C7CE5,$E76B234904A58CBB
            Data.q $123B9387BE76BB22,$DC82C9B9DAEC8F09,$A5F5BD5B30FDDBDE,$020394C000243EA6,$6A75006800000004
            Data.q $3A36BF07073DE2F3,$5240FCAF1BB0EC56,$7A57ADAC5FBD60A1,$30FADD1A405CC3EB,$321F135481CEC3E2
            Data.q $EB22883F5DCA45A3,$ACF557AD6518A395,$791917F3B5D97B9D,$F9D6DEF79DAF2B67,$A79ADABFDB35B6F9
            Data.q $001D09604A980005,$C77D7BB513A80000,$5FC07171BF5793C1,$73047D6CCC1A1A9C,$24590AB9630FADA3
            Data.q $B25BB5532B96EC1C,$56CDD23EB6D541F5,$8364743ADC1F2E95,$AABD6F9457ADF9E7,$8CA3E76BD85CED71
            Data.q $8F3B5E3CE04CCEC4,$EC6EE715CDE70746,$4C000303D96C1F62,$EA00000001017029,$5F870ECFC7D23D40
            Data.q $8F592557D1E5FE7E,$A0FF924DA0DDBAD2,$D4C540ABCC3EB78C,$23EB695BB75D87D6,$2EF30687B068343B
            Data.q $AF5AF51E47EBD91F,$1908938A7F3B5AEA,$73B593772B8B0E39,$F7CEB6F2B9704246,$0233D66E1F5F35B0
            Data.q $00000040206D4C00,$EC4FEC7CB8B83A80,$7E0AAF5A483F5DBA,$4916FF924A211231,$11F5B0AAB165B77E
            Data.q $753CE56D51F5B0D6,$E88FD72D4784B10D,$E54399FEB970E9EF,$E4669F9DAF3557AD,$AC61E11B9DAF4F9D
            Data.q $EEAC58FFBB7B6B57,$8A60001D1E027C7F,$C8D4000000020100,$C1C1F4F03F1B43D5,$373C15A1E683B5DF
            Data.q $2A05C28A7DC157CD,$7D6CCB06C788FADE,$960D0DAA3EB66504,$BAE2BD66A8951F13,$B2AF5B679DACCAB9
            Data.q $ED7A5883B5F11FDB,$55DB63CBD891887C,$CF77DB1BC2F9DADE,$00171E8B58F85E0D,$000000080C828A60
            Data.q $83FBDD37C7A30350,$52ADD5AA2AFF171D,$68BEA11C123CBBB7,$0DCB76EA95E682A4,$9E47C5655E34E60D
            Data.q $2C9CFEA47EBBC8F0,$231188AF58CA95EB,$5472BD6D2A57AC8A,$EAFA50938C12B762,$5A93DE4E2140B4A1
            Data.q $E76BD2AFDB5CB88C,$BFB4165B919C731D,$0159FB3613DDAD9B,$00000080B836A600,$53FB72DA9C285500
            Data.q $AA56E97CC7FA077B,$16BEBB752757F5DB,$2A9AEDD54C550519,$51F5B037EBB7535D,$50E57AC469B0F88B
            Data.q $772AF5BE54257ADA,$ED7954312310FCED,$DB5F69DFEE8ACD7C,$9530000C4F35B27F,$A02A000000010081
            Data.q $D7CAF4743FCDF54E,$B723A5CC7B0B5DAE,$6EA49EF0A481776E,$D2B76EA151F5B537,$3C1CCF07C478C7D6
            Data.q $3CAF5895715EB5EA,$AE70B35DCED773C6,$AD1C49C037BA1092,$ECDF9D2DEB7E76BC,$00647A2DD3FFA3B8
            Data.q $000000582C0E2980,$33E8EF3E91D41940,$235EB185CAF1BE57,$0F0524BB76EB7234,$7C5B5DBAF979F22A
            Data.q $F78C7D6ECDDBAB94,$4E50E57AD95441F2,$A095EB1B990E95EB,$73B59AF154DCED64,$F21AFA9087CC92A1
            Data.q $9CE9D3DE76B8AB24,$01CED63F7F2165BF,$0000000202E0BD98,$CF91C1B9E888A0E4,$947848EEE47E7D9D
            Data.q $F2480FF92575DBA9,$2423EF66BB75CABD,$5D23EB65ADDBAA95,$3547EB987C5D5BBB,$7AD66E56ADD715EB
            Data.q $EF479B09879C93C5,$9D2F164AE576DC59,$F08C49CFD895EB1B,$D5F401D2FC79DAD4,$F9FAFF2D9FBEE62B
            Data.q $0201B4C000303FA6,$BEF2E1C800000004,$32EF2B89F0EDFF0D,$41E192BD1861BB75,$FF2280F852517E45
            Data.q $5DBA9CFD76EADAFA,$0F60D76EAF23EB7B,$BD62D430F972D60F,$B2989C65CAF596E2,$EDCF84CAF58E4684
            Data.q $9264F7273CEF2BF6,$1FEBB5BF3B5DC8F5,$139F3366FB6ED7DA,$0000020101FA6000,$3B5DE9B23D186400
            Data.q $A18525083C7C0FF6,$B82AF1AA643E76B2,$B76EB9ACB37F9147,$AF4A12512EDD6758,$8CFEA47EB99E7039
            Data.q $5D2BA6E90E57ADF2,$28F05D0564B1EBB9,$89ABE3CE0F0B1E80,$48EC48C060D8F4CB,$EAF5B1E2BD624744
            Data.q $7E0BAF1BB9EF1EFA,$816D3000090F69AB,$53FC2C0000000100,$339F8B9EC1FEEF9B,$FBB75D95FB29BB55
            Data.q $5B576EAB1AFE492A,$A9541BB75F9502AB,$A8F8A8D1F5B4ADDB,$2D1DCED673C57AD5,$58965C3EE5151C38
            Data.q $D40514795EB684AF,$C91E1198EE4E6EC5,$5A3042E7EBD5C405,$86C7CAD97BE75B75,$0809D30000D4F35A
            Data.q $7A76334000000010,$1428DF037DCEEF43,$9776EA72AD5897A4,$1195BB7196EFF249,$BB752AC376EA9519
            Data.q $2347959EDB0F8AF5,$2A41E4DCED7B2BD6,$C8C4BC49C65CAF59,$F5895872BB6AD67B,$B66B10BFEEF2CD6A
            Data.q $2D30000C0FE9AF7F,$4888000000010081,$FFB47C7E39EBE99D,$1A647C4A7E6095F2,$F9D9B9D2D179FCAF
            Data.q $DD766D7CC3C675F0,$2BD63C63E27D512E,$5C7938C795EB06B7,$39393BB918C63E5F,$C3882B9370FADADC
            Data.q $68DD793BCF30DD19,$33000090F29B47DB,$F598000002F0D402,$FD5DCF33F8FA47A8,$2B7633AE8CAF0BF2
            Data.q $5243A08FD925903F,$2DDBAF94EF915EB0,$9B5DBAC4D57CDD32,$7EBE9E7ABB23E272,$B2CA57AD65E76B24
            Data.q $B1E7C24CAE4E315E,$177727107EBECAF5,$9E78B25E12301127,$962B858F0918AF58,$E9AC75BD5B0F79CC
            Data.q $0405C16D30000D0F,$B1F2E2E7ACC00000,$A1EC07E199FC71FF,$F7F924CFAEDD6CC1,$E34D76EBA4E60A4B
            Data.q $ED76EA7A91096055,$958EDB0FADA5481C,$A958AF5AE47ECEC5,$95EB19E5AB35CAF5,$D9E582CA59D05788
            Data.q $7BC8CB3C49C457AD,$F5B6E78B279DACC9,$3F56F63FEEDEF6EA,$FD30000ECF95ABBA,$19AB300000010080
            Data.q $F8383E9F17E9B23E,$FC9376EA6572C6DB,$9159BC14943F2287,$6E82AFD72A15A37F,$2AC2415F152A2ABC
            Data.q $E279361F5B79BB75,$157AC9556AD64B23,$5AE5138AF5B48F89,$ABB5552AF58CDCAF,$5D69F72308EE57AD
            Data.q $987CEF421EAFABB3,$F1EFEDB7E69B8FDD,$6000119E3378FC5F,$59800000160B0166,$F3BBBFEBD362704B
            Data.q $1B72A0478BE267E2,$96D12FE4549FC2AF,$EDD4C3D64C2A2D2A,$21578D35D7A92C06,$7A861F5BDAEDD7E5
            Data.q $DFC55EB6AD0CAF1B,$192127176F2BD65B,$EBA3919060666DB9,$97F71B7B51975D76,$6C27BBD61EF3992E
            Data.q $40201CCC0002B3D6,$6D8F464ACC000000,$31B1FEC181C76DBC,$AD5E36E4705A85E9,$783A572DA9DFE495
            Data.q $3C674AF1A8C5505E,$CB76EB1362DDBAEC,$AF5B351FAE72AE5A,$B195EB79515EB694,$D29E4E31E211195D
            Data.q $E12721FDC8CD3B3F,$21123CF849578D25,$FF6F5B41FD74576B,$06F4C0003B3D56E1,$750EB30000002C16
            Data.q $B8DFC333B1D7437C,$A4811E129F98257C,$7C29205ABC6AC142,$EDD5690305C78AA3,$A4DFAEDD76578D5A
            Data.q $EBE944BB356ADDBA,$284AF59F54E7EA47,$01732C76995EB29E,$3C7D891987074789,$ABD6C58AF5891D16
            Data.q $FBCC79D93FB4165B,$054CC000253FF1F3,$F50AB30000001017,$5E97F0CAFB3F1F48,$981576DC5D6C657A
            Data.q $3C1490E8FD9587AB,$5E354C99F5DBAE98,$D6EDD7F1B2EDD6E5,$F59F5E78395BB352,$3A51E57AD72C61CA
            Data.q $95E375EFD0EDEE78,$CED1DAFA3C387AB9,$0DEC3DEDB9BD6F87,$F59800000FD9655B,$71566000000202E0
            Data.q $BAB99D8F27D8F961,$EAF1BF2A8478CE21,$516B9D2F4F0292AD,$D761A11A2ABC6D91,$1F11EB76EAC6B2ED
            Data.q $9188257AD237DE95,$93882211195EB1C8,$9657AD3018918C7B,$DCEF60E0C9E1CAF5,$0F69A67D1F2B61DF
            Data.q $000100812330000B,$E7F1BA3E186B3000,$CA34233DFC1C1F77,$697D7F9149BD5E36,$AEB73A1454A055E3
            Data.q $C874AA4AF1A67E20,$86E7035ADDBA96BC,$D28E57ACC6F3C1F2,$EB6B9E2CCF2FD73F,$C6A9E21C49C43795
            Data.q $1D4592D383EE74AB,$E536DFFB63B8E9DF,$0020103466000141,$77CDA9FE05660000,$5240FD67D2FBB93F
            Data.q $C8A75E0ABC6F9618,$7DED667CA6D91A5F,$24A870BE2AF1A4A8,$AAAF1BE51E2E6E74,$57AD651FAF7A8F8B
            Data.q $CA47BEC9457AC154,$843C2373B5A2C57A,$4FB9392127242462,$D8960849CB882CEA,$7973876755F374AF
            Data.q $00A48995F78EFCC9,$00000010080A4000,$FB9DE2F36A751E33,$1FB24ABC6D91BE06,$9347E0A4B56AF1BA
            Data.q $2A1E328C131987BC,$AF1A65232F8DDBAE,$B7284ABC6D28F88C,$72BD639ACE0D51FD,$ABA592B95EB12B14
            Data.q $14312310F7231977,$ABD62476BE843B5D,$EAD9D7E7B7B6B5E8,$66000121EB8D2FAD,$346600000020100D
            Data.q $BE8727838EFAF76A,$FBF8F3C1D95E3765,$2BC6FCCA37FC9205,$1578D3728137341D,$5655A34CC5578D5A
            Data.q $CF06CABC691A187C,$6EBA12BD6D9ACFCD,$A68E24E65D5EB637,$461D773E15AE57AD,$EDDACE757C7716CB
            Data.q $F9980005E7ACD4FF,$28B1980000008040,$97F9E97E12373A22,$156AD8AB7634EEC7,$45BC1490E8246224
            Data.q $E2EB2BC6FCA8E851,$F1BB0F88CABC6A91,$AF58F536BB7599AA,$57ACB32E57AC06DC,$85B2BD624E12314F
            Data.q $595E25DB9A30EB87,$00323E26D5FB3D78,$C000000402002CC0,$E8E8FE879ED2E58C,$34585250831BABA9
            Data.q $F248E855E3748F39,$2ABC6F97B414901F,$3EB686ABC694D532,$0E3E2BD6BD47EBAC,$5B4D5C49C83895EB
            Data.q $DE5CAD5EB697E2AF,$7B4D8B8DFD5B30F5,$0008040159800060,$EF4D91E8C9198000,$CDD7B7DFA5E0FA7A
            Data.q $D0DFE453EEAF1B73,$5E34B51F1195E358,$F5956B3FD87C578D,$BB5DDAEB2FEF984A,$F3ADBDEABD632AF1
            Data.q $8F89BD7FB66BEDF3,$000100804B30000C,$ED796E4FF0E33000,$AF2E145DFD2F7B13,$EAB6FF22B77578D0
            Data.q $2501578D2501578D,$9257D42AE1A6578D,$B5115DB5E3578D72,$AFA55C8C65CAF5BE,$B961C72BD6464F21
            Data.q $AB45FFF76E9EABD6,$4144490020000049,$7BCD5BF93D1BA554,$00080404D9800062,$F179B53A85198000
            Data.q $1D8AC747FB0607D3,$56AF1A661E6CBDBE,$A1578D6D53FE0A49,$F3A6EDD7AAAF1A4A,$C3F5DE47C57A861F
            Data.q $9C83895EB556B3FE,$5ABD6728F99470C4,$5D6FCEECC3D75B75,$205ACC000283D71E,$93D418CC00000040
            Data.q $B81B6F0CCE47ED7D,$B9D0991F1294585C,$AF1AC69EFF24A37F,$544578D6A90595A4,$1F1687F6E2BCE57D
            Data.q $DD4CAF5BD68FD7A5,$BFFB6B57AC7370AE,$B89D980005E78CD9,$CD000000000BFD93,$8C2F7399F6BA79E2
            Data.q $6ED554A95BB136BC,$BC681A07ABC6EA10,$8555E371BB75A562,$60E8EB51F13979D0,$6552BD60AA95EB45
            Data.q $F58CA85CE57A57AC,$244E12714F12314A,$02BD6071CAF58C3A,$000000405C173400,$0F37E87C1CAE08CC
            Data.q $1A1578D305FA1B1D,$F71E73A578DC55CB,$88CAF1BF8CE60A4B,$8D44578D8AC9508F,$5957B95EB0C98F89
            Data.q $796AB838339E74B2,$2F1800057AC0AFCF,$633DA60000002010,$4F81DEE4F7DD3747,$8DD87ABAD0A4A105
            Data.q $F64557B829284157,$6BB753D55E3426AB,$9FECDD6AD91F1593,$60DE4E3050707AB5,$39A5FEDBD5ABD68D
            Data.q $0100819B30000C4F,$A1BD3B19AD300000,$E4BE04AF81C1E777,$77F95E36C8ED75A1,$E84CAF1BA797F249
            Data.q $578DED550ABC6EDC,$679E78B3D6EDD6F5,$472BD6B6ACFE8ABD,$BD6F995D07069AB1,$000AF5870E4E5D72
            Data.q $4C00000040207CD0,$8D8EC75D0DF1D45B,$2362C5E70D5D0FF6,$4D7FC926582AF1A7,$F5937CAF1BB0DD74
            Data.q $C6B6A3FE4CAF1AB0,$9B23E2AD79F0FCAB,$2F1972BD6CAA20F5,$ABD6A58363455EB1,$D4B86AF5A3556EC8
            Data.q $DF3AAF596670E57A,$842059A00015EB0F,$E888A25A6000000E,$D1C3F8BE2F830FDC,$5CD5E34979B2F675
            Data.q $B39609860468363D,$6E554AF1B551F328,$5E742E54EFD692BC,$967E61FAF647EEEF,$D7D0ED759572BD67
            Data.q $0B124113257AD88D,$CAF5B406AF59660F,$F3C75FF47ABD66AB,$00101706C00000AC,$3E1B3D8192D30000
            Data.q $23E5C98DD5F4F47E,$7C292B88C58C1C19,$3A15230246EF9150,$D0AA2BC6DC8D97D7,$5578D0A8F1779578
            Data.q $910B656ECA79E2EF,$A1E112C61CAF5871,$BD6B2C1C1995EB12,$207CD0000AF582EA,$470A3B4C00000040
            Data.q $19BFE07075DC6F37,$2FDCE8765FA855BB,$AA49EFC92CDFF24A,$78DC62A054927D75,$CE84CAF1A9AC9015
            Data.q $A8976AB5AABC6DEB,$A3F5C9AFADC57AD4,$7ADA1E326395EB36,$39E35E0E0FE78825,$57AC056AF59657AD
            Data.q $0000020103E68000,$27BAD0F638515A60,$AE48EF9462FA5DF6,$E1453AF079D0D91E,$3635E74261F5BD62
            Data.q $F3A132BC6E95495E,$379A8F888D578D6A,$84AF5A6557ACF23F,$8CA3C8C55C40764A,$30F096B95EB74AF5
            Data.q $0015EB01FBB32BD6,$98000000804055A0,$BC9D0EF37D23A836,$ECD74AEC246D7FD6,$9DC1492AFEE743A6
            Data.q $A95E7438AB83EB7A,$CAF1A46F3A1B2AF1,$7FB2BD6B23E66B50,$75E843A51CAF5B6E,$72BD6728E08CAF5A
            Data.q $5E2DDB9ABD6B9E5D,$B40002BD6071D1B8,$0B4C000001D08404,$5F43CBE4FC7D23D4,$647C4A6F58C2E579
            Data.q $6BA4F7F925F3E743,$B2BC699879D0ED76,$703BAABC68CDE743,$4FBE88E88CAF596E,$9D481C99E25CAF5B
            Data.q $12320F0A87A52BD6,$9C8F574582B938D7,$AD857E3BCB95ABD6,$C04B40002BD6147E,$FCE0B4C000000405
            Data.q $7DDAF67E9D4FB1B2,$82C79C0A208F9DA9,$89D0A2A0F0524DA4,$D5F455FB594F8404,$642660F88DF2BC6E
            Data.q $7936578DB2375C9E,$5EB44DE702BAF3A1,$405F657AD6486B99,$468E24E41BC8C65C,$1CAF591576C88F39
            Data.q $020389800057AD07,$F0F86794C0000004,$FD37F06873D85FA6,$208DCE874C585240,$3982922DFF2495F1
            Data.q $02AF1AA649F0E091,$A73A1C55E34C382D,$0654ABC6B979D0D2,$F3C1791AAAF1A724,$5E783B2BD6599F92
            Data.q $AF5A947C6D157AC9,$EE4E484AF5B1E23C,$8F9924E395EB6953,$7F1A87FB7D757AD8,$0010081D50000052
            Data.q $D7C6C4FF1A530000,$29207E33E97BD8EE,$2BBF5DBE0B76AAB4,$2635817F22837829,$935DEA998BCE8568
            Data.q $BC69CF321D722909,$23EB7C6A273A16AA,$4532BE67DE646EBA,$32B15EB4CDCAD5B1,$F72BD6D958872BD6
            Data.q $D6D375C9CC312308,$62B57AD8920B572B,$540000191F38D0EB,$4594C00000040204,$DB2BE1CF70BCDD1D
            Data.q $B2B96EA1ED8AC646,$275FC9225123CF17,$F2A55C1AAFA35FC9,$6E7424A03CE8761F,$6A83CE569242AF1A
            Data.q $F580D1F5BC379D0E,$BC889C57AD8A298A,$757ADF3C412BD632,$C6B95EB692389385,$057AC2B757AC6576
            Data.q $0000074210189800,$CFA3BCFA47512530,$DAA7160C1A5FF50D,$F9150C2AF1A482AE,$587CEF527FF24B37
            Data.q $0F3A15B9D2F1E76B,$8475582C6860E8F5,$FCDD936578DBC7CE,$8395CD72BD6CAA20,$7986448A8E576D27
            Data.q $7271444230F5725F,$C232BD6D3C123277,$0015EB079C1C1E23,$C000000405C06260,$EE737F23ABA5E494
            Data.q $7848F3A1DB776BC5,$F45BC1490E905758,$1B990EA40A4943D5,$52BCE8761D1695CB,$ABC6ACDE743655E3
            Data.q $315C57AD951FAEDA,$B96312896E782662,$0FF933C8C420B38A,$D6272E24649EE4E2,$65AAD5EB12B3872B
            Data.q $289800057AC30F3D,$AE394C0000004020,$FCAF470381F4DA1E,$D7361D7DF73A1D92,$F2480FF924742402
            Data.q $FA079D0D9E7024BD,$6CF3A15AF15711E2,$E368D0DCE85E55E3,$2BD63D79E0F95115,$11157D0B9E0E28A6
            Data.q $E57AC4BCE095EB19,$3C57ADB20712330E,$DB9FE3B4BE5ABD65,$00189EF8E6FB6ED7,$80000008040ED400
            Data.q $6A7BAF6DEC704529,$D1E9E743B4BFC5DF,$BFC8ABDC157AC8C1,$7C46E743B5D6A921,$E5E2BC6995BB4D14
            Data.q $C7CE86CB2542AF1B,$FD4F3C1A5441F5BB,$FB78B19C57AD4A9C,$ACA572D8AB56D5C3,$510195A4382341E1
            Data.q $ACFFA5DBC9C55C8C,$E0B8B9C3B3AAF58C,$000159F46C1F39FA,$9800000080402340,$3C3AEE179BA3A832
            Data.q $9E74267A4C6C75B0,$35FF2481F7F4B058,$1F3B307891E5FC92,$E2A54549721E7826,$61F11B9D099F882B
            Data.q $8B52B5578D234644,$687A1F122CFCCAF5,$5B43F36659CC04D0,$7FA10E08C3CE4CAF,$91867893883EE716
            Data.q $E57AD73C1093817B,$AD887F76F4D68C38,$00000C8F1C717ADC,$94C00000040206EA,$BC30BF8EF3E91D40
            Data.q $95DB49516172E06D,$4956E0A481079D0E,$1BA95373A1258FFE,$C692A879D092ACD9,$6750ABC692C950AB
            Data.q $322213579D096A42,$5B48FCDEC591B2E7,$57AD72CE70B328AF,$1E57AC7272BD658E,$328D64351E71E4E3
            Data.q $DB0E88C3C246F772,$FC75174B4670E57A,$4784D4FFFD359CCB,$002C168175000007,$FC8EAE5782530000
            Data.q $72BC5D791B9E673F,$8AB9DDCAEC3DF66E,$ACC055DB54A93782,$D5E6EB373A1D2BC6,$8F3A14A918B6E742
            Data.q $DE47841521B367DF,$ACA79E0EDEFB23F5,$7E6F472C16C78A57,$F5B167FD10896508,$9A7BC9C4B87EBACA
            Data.q $AED89E36DC8C9093,$E399CD1871CAF5B4,$9E46E1EDA9BE2D0C,$00405C178C000013,$FD3647C33A4C0000
            Data.q $CB082D7E57A3BEE2,$925FBFC92E03CE87,$68BCE84CDD0AEAEF,$EDCE86AAA48BCE85,$1FD512BF8A222BC6
            Data.q $4A8F8ACA3F99E73A,$7CC773C1D28773C1,$CB95EB36AC57ADB5,$D6472FB919E78938,$EACC415C9E7C28AB
            Data.q $B72B661FDD15DAF9,$8D000006E7DE30BF,$F152600000020100,$7F4B9EC76BB96F8F,$9FC29207EE742953
            Data.q $71FDCE849F5FE455,$CE863556ED73CE86,$F9BA544576CDAB25,$6BB75450E57AC951,$FB78F104CFCC3F36
            Data.q $5CEFFE3CE5DEAE23,$5CDDDC8C6311357D,$3E2455EB54B39D2F,$EE3BF7CE60B2DD38,$0000191E38F4FFE8
            Data.q $9300000010080B8C,$81D1EF7F37D53A86,$BE1E742F3CE97B7E,$EF1E743A5B7F9146,$ACD635DEAA99707C
            Data.q $C7CE8719243CE86C,$1FAED51E159578D3,$D6F9F7A23A237BE6,$231CAF5A61F9B32B,$A0E0F42BBF54544C
            Data.q $B938C5E6795EB563,$33A55DB4C089387B,$2D8F8DBDA8CBAE1F,$004ED46BFBCE65BC,$000000402012D000
            Data.q $DCFC7E3E91EA0A4C,$4315C5FC970BD6D0,$574DD5AFF9244BE7,$5E34C8C8B1E74265,$1BCE85644973A1D9
            Data.q $67A861EAF5AABC6B,$5EB59E5828A1C3F3,$3766BB7405E3C509,$AF3DE4665F72BD6B,$EF57620AE4DDCED7
            Data.q $D8AFB67FF3D15EAE,$4D00000647C1BA76,$70A4C00000040201,$DAEE799EA7D8D97E,$3CE849DDE743153D
            Data.q $B6BE83035B9D2EC8,$2BCE85CAAF1B6565,$74ADDEAB54D95E35,$2AF592A3F375A8FD,$C16A23D65190FADE
            Data.q $180DC9C541B1E9E2,$ABD646ED575C5D89,$DBF305AF44E20AF8,$A7B1BCFF731F76F7,$00040203CD000005
            Data.q $CFE36C723384C000,$CE97159BF83439ED,$2C9B9D0FCBDCE84D,$F6E2A645E503A848,$0DCF876E7425592B
            Data.q $61F9B2D4B2AF5AF5,$55EB2555634CAF5B,$B9388257AC4F3814,$C4AF5B42E78BC592,$DE2C1091816E4E3E
            Data.q $4DA3F5D1E78288F8,$6F63EF1DCDC970B0,$E1300000D8FD9ADF,$FC50980000008040,$67C0F7727CEE9B13
            Data.q $DCE97A74FF9D2EAB,$22F3A1C62A054927,$5E354AAEF5515E8B,$107DCD1A1B9D0B55,$F587567F523F5E95
            Data.q $AC6F7A32387E6CCA,$62539EAF121AE657,$17586C612714F2BD,$BE6EB9C0ADA7B918,$71FD76F75777ABB2
            Data.q $00E0F5C7076D9ADB,$000000804049A000,$8FFB79BE91D43098,$E84C3B168C8FF50C,$24ABF9D2D48E88DC
            Data.q $3A125573A179BDF9,$168F39D722909937,$FF61F9B728F3CE87,$1D5D782A657AD679,$43DE711A113CE72A
            Data.q $157AC4AAE58CAF5B,$4AFC47CCAD3B1232,$33DA3B6FAFF357AC,$00000BCF2344F827,$098000000804015A
            Data.q $EAF0FF4FC7D23D41,$23C22796140FCF97,$FE4922F9D0A91D12,$3A1C5B179D2FE78F,$36DA8FD7D87C55AF
            Data.q $596BBD5D2BD6EC3F,$312896E782B2B8AF,$5CAF59657ED89097,$D6448EE4E21C48C6,$7C3A20AE6BB3532B
            Data.q $E56CFDE73ADF972E,$8C0000229E737E63,$C21300000010081F,$FC3B3C9D1FC2DEA5,$8561E1695766A4A6
            Data.q $B90A2BF705153BCE,$1AB379D0809DD3AE,$967F447E6FCA88AF,$0E28A62BD630FCDE,$73E5A3C1FBB30B9E
            Data.q $41BC405CCABE6ED7,$0AE4B06464F1EE4E,$2BFFD75B755A30E2,$000093FFA8EFF656,$D00000010080EB40
            Data.q $C0FA7E6CB6C70A72,$42661879D0EC47C0,$55CB22DBCE874CE7,$2DA2F3A172F3A5B9,$0A8F5753CE84CA3C
            Data.q $87EBA547C495578D,$30FCD923F5FCBEF9,$743DE71E783B7401,$4AF0554ABD6D95FB,$479BAF42464EEE4E
            Data.q $35E8F0E1EAE8F3E1,$68FB1DCF3738AE6F,$04045A00000D0FC3,$F538529680000008,$2085F0B9EC4FEDD0
            Data.q $FC1515083CE87150,$498DFE451EFCE84C,$6E74B0AABB693CE8,$273A14A8C08DCE85,$07CB91A3EE52BEFD
            Data.q $CC191AC88AF5BE51,$C787E6D4A2707E6C,$278821B163C4B938,$EB158CF7401D1059,$7B460D0D14312304
            Data.q $C1093975C3E6491F,$FA3F615FCEB2E568,$B400000D3EC6919D,$432D00000010080E,$FFB8747439EBE99D
            Data.q $D96574DD2BB168DA,$55FC921DFE4942AE,$92AE7428AB8ACDBA,$CDE74BB952A2F3A5,$FD732DDAAD579D0E
            Data.q $254773C132BD6728,$3D5D141F9BB2ABD6,$0B93C127104435CC,$674D7B87DCA3C788,$5ABD6D95F3749C3F
            Data.q $FFFEAAC41FFBB4B1,$C2AD000007679E35,$CCC00000005FEC9D,$EE7F0E2FB3D11144,$1578DD8155850B95
            Data.q $2A1879D0A2142A48,$CE849F5FF24817F2,$3CE85157EC88C08D,$22B6EFD743CE5660,$FBD157AC7A895E74
            Data.q $57AC49039255EB7C,$8C4387E6C9657CC2,$D3DE4E273C59995C,$5DCE97B0FBDEBDFA,$B6C6FE7BA74F5187
            Data.q $600000CCF234EFE2,$4B4000000405C022,$75391EEFC36FB2B8,$C2AFD96BAF5C7375,$D0F965DA09059462
            Data.q $E74375348482BEB9,$DB0F2D987E6DF544,$E59660883CEAE57A,$8938C1F16C3D64CA,$B24424E43FB91967
            Data.q $EEAC9046E84261F7,$1B975BF3BB20FEED,$40207AD0000034FB,$A6D8E09D34000000,$30824FF060753C37
            Data.q $C3EE49E7424C1B1A,$3A1F93983CE85197,$9373A125808FB937,$D6ED5139D0C898FB,$6791F9BF94E7F8AB
            Data.q $5C6095EB63C412BD,$60510FCD92F160B7,$4AFDB6574DD5EEE4,$8EA2E968CE1CAF5B,$1EBA91FDBD5B697F
            Data.q $002010304C000016,$D161BE3A8A9A0000,$61E4BE06B79783CE,$9F8306C64AA572DC,$A6A375F1502E1452
            Data.q $5B5AF3A11A9F39D0,$5BB0FCDECA6D8CAF,$455EB1307478DCAF,$A03A47AEED498403,$2D2AE58C089397BE
            Data.q $5E1F3B4751871C3C,$0069FFD6AFDB7D7C,$0000010081626000,$F3D8EF3E91D434D0,$D62537F90E0CAF85
            Data.q $D5FD06C6B7381D2B,$D4AB83E5F5DBFC92,$BABBB5479D09A0D8,$39D0C89C1B1AD76A,$D95EB12883F5FE51
            Data.q $6CC48230FCDD967F,$E657AC6F7A32387E,$F2BD6252EF57121A,$02F7271840B68F14,$5726E570DD59EF23
            Data.q $63E7B7BAB1FF3B10,$00E4F635CFEDF6EC,$00001D0840E26000,$9E4FEC6D70B8D340,$60478BEDEBDAF679
            Data.q $FF249E7CF5661E2E,$A0A924F878CE328D,$8A3FE75F73A1258A,$EAA273A1D13596DA,$8A87E6EABEF373C1
            Data.q $E572CB0D88DC55AC,$AAE8363B377AA4CA,$9278727276221AE8,$E1777ABA20AF88F9,$517FB88F3BBBED8D
            Data.q $17004980000303F7,$C8E4614D00000010,$419BF83C3EEDB7A6,$8D4A95AB23CC0518,$A1457EF0A48E060D
            Data.q $DB9D0FCA7C365D13,$0954C7448AA18363,$10AC70FCDE55139D,$2E61FF3A60E57C7A,$FDB13BFACB05A61A
            Data.q $247772BA641E1ECA,$AEF57657AD341B1A,$B0AFC74B725C2C10,$0000227F8D956FB7,$8C00000040203898
            Data.q $1FEC766B4DC9C29B,$6EC574A1EBB45CF8,$E493EFF24A1E7426,$D5464A079D0F54F7,$0448F39460D8D6BB
            Data.q $7E6F8D44E7432B46,$1E74A212FABB3524,$A8F39F0985CF0744,$101732AF9BB5D77E,$8ABA692C7B93886F
            Data.q $DD65AAC7E6D657ED,$07AEBFB6DCADE17F,$0008040893000006,$3AE86F8EA1718000,$2BB091B5FF6AFC7C
            Data.q $1AF879D099E683B4,$B36373A1F96DE145,$0E89AC16373A14AA,$EDD004C3F3678F9D,$732C56D0F79C79E0
            Data.q $4E2894461EAF8911,$42572C89C2464EEE,$BA3387118911E118,$AC7E8F9EBB9C47BE,$040B930000044FBE
            Data.q $85ECF17180000008,$5D935B1F9F2F73F0,$FC922DC1E743B73A,$3A12640F3A1F2B1F,$347DCA579D086B0F
            Data.q $377A915132F07C43,$72D88FCDD951383F,$3B6AEE803A202E65,$AEDA8C18919A7B96,$64064C3C2279D0A2
            Data.q $677E8FD987EED2F9,$039300000727B1A4,$72B9868000000804,$36F439391E6FE360,$79D0AD06C78AB363
            Data.q $459F22B37828A1D8,$E23DB7A836352382,$60D8F6582C8AB9D0,$E86668FFDEDCE85E,$8DE7FDB9E0B6A89C
            Data.q $405C9E0FB9C47E6E,$FBB91947772BAE3C,$F5B48F8911F7BC78,$BB5F6A7F8E92F96A,$980000407F753BED
            Data.q $4434000000402064,$F8BBEC77EBD36270,$D7341B1EC3C5CC3F,$B22DBF41B1A29090,$1B2B1DB43EE4954E
            Data.q $79D2EA4E0D8ECF3A,$58870FCDFCDBAD5C,$C9C55CAF596572D4,$44ABC6E3782BA3DB,$60774EAEA30EB878
            Data.q $0044FB1AB7E20DC1,$0000008040B93000,$1D769B86CCF51BA8,$3A135CAF8295F2BC,$E8C28AA2C377ABB7
            Data.q $9F0D0894DFE457AF,$23FE74C8B06C6A64,$87568C08CC5E7427,$5EFEA47E6F2A89CE,$47E6D4F1421F9B03
            Data.q $9C65DD004960F59C,$F59D722FB91917DC,$6482C7875D77AA48,$CFFB7AC3BF9D6DF5,$016A600000A9F6D7
            Data.q $23D42EA000000201,$9703ADB1E9D8FC7D,$E494AE0D8E2A8B0B,$43E2595C1F2FA1DF,$3A14A9ABF6AC3EE7
            Data.q $41F9B8AF3C1EAA27,$F366E702B20FCD99,$808FCD92AC564583,$EAF421F9BD3A7891,$9E6F8BE7AB44E3B9
            Data.q $FD7CFD1E3BF6BDF3,$201006A600000A9F,$C2B2E2E2EA000000,$C7150DE47E7D9C9F,$0D8D63DFE493AF06
            Data.q $74261E33A079C0EA,$952A54B9D0D2AA1E,$C17D5139D08898FB,$A1A89C1F9BF2A273,$B939FB12718F0FCD
            Data.q $65D70F0B4ABC69BE,$F6D0DC16C6C6D6D4,$D26000004C2638F0,$8533500000010081,$BBF03C3EEF365B63
            Data.q $D8FE61860D8D107E,$1B19CDD0A280F060,$5BC75C6490AB76D4,$8444C7DCEDCE84CC,$4E7F88FCDF6A89CE
            Data.q $9BAD79E0EC3F37E5,$A7B918077271821F,$8FF9D87BCE87ABAC,$FF6D7DA27EE62BB5,$114C0000243E86C9
            Data.q $D8C4D40000004020,$73F177D89EAB4DB1,$EF5748FB9460C8D1,$199414919FFDEF46,$5CE87183635A2C1B
            Data.q $A8DD7279D0EC435F,$EB049ACD625E743D,$257272421F9B2355,$F3A1523E24477723,$C3BCF38DD38B01B8
            Data.q $074781B4FEE7855D,$000010080A530000,$3D1C77D7BB515500,$1593D85AED7FD435,$1B1F1ACB8363251D
            Data.q $0EC3C8FB9B230234,$C55EB3547C478F9D,$72D119E1F9B05BEF,$2B987E6F4E189182,$BB5BB2E4425D1388
            Data.q $64FF6B09ED77661F,$0001008135300000,$799F8AC617955000,$73A1F338F6E17CE9,$06C7D545C1B1A91F
            Data.q $4DA0D8F26FDCE84D,$F5C947E6DCA3E2A3,$8EE4632E1F9B89A3,$785B0FCD92871230,$5A7F75972B41F168
            Data.q $00191E3AC9F57EF4,$0000004020594C00,$F07CBF4DE1DAE454,$ED49578D27CFD0C4,$6C7A399059D4586E
            Data.q $8DE743B41B1E5790,$4A8F2AF1BB360D8E,$F6E78261F9B373C1,$36B5C3F3706B07E6,$5D3D1F16960B623F
            Data.q $CE6D1FF8F4374BEE,$040207C980000327,$5E5B53FC59400000,$0D0D157F8BBED4F5,$4A28FB9C60D8D4AA
            Data.q $6C7FAF68292CDFF2,$D441F725AF3A1B30,$44253CF06B51F11C,$B92ABB9E0995EB2C,$69A90D735D4A9888
            Data.q $7E6FE4424E25E3F3,$C43FBBCBD5A72EB8,$0003A7DF54363E56,$80000008040BA980,$AF47839EBE99D45C
            Data.q $BD6C61ED95191D6C,$851527E08FB92552,$84D06C661F73F30B,$FAA3CE518363B3CE,$1F2E78F9D0B560D8
            Data.q $73C1F2FBD1E782D5,$7E6FABC4173C139E,$6523F3689EC48C84,$F8EA2C9777AAB2BF,$A7F8DABFDB35B6D7
            Data.q $00080407A9800003,$B3F8717D9E5C8000,$CD06478DEB185CAF,$F05242B8363D87CE,$160D8D6F87DCE923
            Data.q $1E1B257CAFDB8A95,$DE7F8F3A5D2A241B,$C1791F9B1D55DB48,$8C7B9E0EC3F37B73,$20E24632E1F9B4D7
            Data.q $1B7B47E6FCAC7727,$FFEBD7EDBF3C5B1F,$010081B530000074,$7F1B4395C2500000,$3D5D4B6FABA9C8E3
            Data.q $137BC292DD8363B2,$8D4C5505494811C1,$D860D8F61F73660D,$C1728F8AF1C1B184,$9B79E782F3CFFB73
            Data.q $37A5870FCD994E1F,$E6A3C2BBC8C65C3F,$7D7457AB1F9B0AAB,$109FFD4CF6DAAD82,$0000201036A60000
            Data.q $C776BCB727F85200,$F7248F97329F4BDE,$BF78524C847EEC91,$5167C3D5F195DF22,$CAA4860D8D68BCE8
            Data.q $06C746DDBA9A0D8E,$D23F5FE43738159B,$9DCF0761F5B373C1,$9E0D91F9BB3CF04C,$E53848C5DDC9C50B
            Data.q $CDDE3BCEB86E3F37,$80000427EE6B3FBD,$18800000080401A9,$5B8343DEDE6FA475,$6055DB5685E9050B
            Data.q $4546F05150C24065,$060E0CC3E5D10DFE,$F40C1B1AC08C0914,$0D8F66F3A1D7C3E5,$D92A2273C1BD4BD6
            Data.q $5087E6ECF3C130FC,$F0761F9BDB9E0E3C,$5831232CF727105C,$B44580D370E1F9BA,$FAB63BB2AFF77162
            Data.q $8145300000B0FAE3,$8A44444000000100,$030B85FC3F399E88,$7DCA2AE9AA41A585,$490AF4757F2C1698
            Data.q $FCCB90F3A1D2CF91,$FF9B306C6DAA41B1,$73C1FC689CE84568,$57C6108C9E711887,$BE3C58AC8F3C1D0F
            Data.q $230290F9458CB88C,$D23C5D11F9B26F77,$58A3FD7717CBBBD5,$000213EF8DEFD5FB,$000000040205D4C0
            Data.q $1DEFD0FFD95D1111,$6E23C5CD5BEAE67F,$DFF249D71F73B2B9,$60D8D4C99F0C8918,$EC415D148A3EE751
            Data.q $D8F61F738A2487DC,$A5B955BB5964A860,$9646FFFB23E272F3,$B9CF07E50EE78246,$38F3C152C41FAEB2
            Data.q $6A3C4787EC932E74,$0FCD931449C7DABE,$DD3ABA8C3AE1F33B,$CFAD56FFB5E69B81,$00201023A600000C
            Data.q $3FD7B6F138280000,$0587A84193E07FB5,$E023EE4CAFDB1943,$72BD1D0A28B78292,$6A32E7C28C1B199E
            Data.q $3D87DCBCF441D2BB,$51F12579D2EF5836,$B6C9CFF157AD5A89,$DCF04B51F9BC515E,$9CFD1E3043F364A1
            Data.q $FBD59EF2302F7271,$72B840330FCD991E,$6B17ADCAD947E779,$00815D3000006679,$EAF3F2D99EA10D01
            Data.q $1BFF887F525FBE99,$69BA6F4EA3BA6002,$A3C97C095F4B81E7,$C3CF8491F33B5D7A,$761F328DCC14569F
            Data.q $B06C7AB6ECD4C3EE,$48F3C14A8D51F151,$A173C1791F5B447C,$D57F1574D373C1D2,$728E9E2464AEE76B
            Data.q $5138E1D11878461E,$BE3A3BED4DD1640E,$0000C3EB8FDFE8F2,$A3750478FF0034C0,$7C17D01055796D4E
            Data.q $3A812DB9FFD67E5F,$00009DFEC9EAF7DD,$1D9EA7E3E91EA18D,$F736517F15E0D2FB,$BF229D70AC365A11
            Data.q $98AA99160D8EE657,$88B51E60D8D668FB,$51080CBC8FD74A8F,$ED8DCC875773C1ED,$E3DC3F3667A00E2A
            Data.q $8E88C3F368E1DC8C,$6F0B042465D77EB8,$0E38C3FB30FED859,$5010081633000003,$FF4902EBC6DF6A17
            Data.q $F8A52914A57114A6,$37F2DE9E13DC5058,$01FBFD9379A6D8EA,$A763EC77A063EA00,$E56574D52FBD5DCE
            Data.q $FF925F305150C23E,$EE4D06C7A56EDA93,$B933F0FB9532E423,$71A8FBDE306C7B0F,$2FBFEF23EE5AB06C
            Data.q $54EFF659FF61E7B7,$95EB29E783647EBA,$3824E210D7C47ABE,$871231AF70FCD92F,$CD991FDBD707D6CC
            Data.q $7FDD5BD3FF5DE58F,$039980000293FCB0,$A761444519A80804,$7F8A94AF9A2955BB,$128C0FABEF9114A6
            Data.q $B2D865F96F4F089D,$DF74DD1D8C1E9800,$C8541FABFF9783AE,$87DCA3FB8292387D,$C7A847DCED06C7AF
            Data.q $5521F7BB23EE4D06,$09EAAEDAB51F726B,$19773C179AFE939E,$6843F36B3118AE23,$C3F3767DF2582251
            Data.q $5CB88C5A3DBC9C55,$D4670EE78B279EAF,$AC7DB44EB85E2DD3,$FC00330000040FA6,$F7E5BD3C8CD41143
            Data.q $84BE87C565F754A5,$77F931B1FCD22C90,$7CD99D53B4D8EF63,$A84A8000B6FEE4D7,$97F2E87D3D161BE3
            Data.q $F73A47DEF4F25F02,$1F324EE82927DFE1,$B3D60D8DAA3EE68D,$B9E0DEA3E648DE74,$D7C514C57AC65FAB
            Data.q $0562032B7094588F,$178938CB87E6CDCF,$EDD74212732FB919,$5AF46EBA0D8F1672,$875B1DD887E76B75
            Data.q $814D30000050FEEB,$2FB96CCEA1350100,$5EA507C5F28FE90C,$F4EE4D7ABAEEA041,$FE7EB13A8CFE6C4F
            Data.q $BBEA2C8000E6FEE4,$F2E57C2F9EC7B8F7,$76EA61F736537F90,$6DE1452AF8524083,$CD6B06C661F7372A
            Data.q $CD62A3CF3A12347D,$0B54A741555AD66E,$9B9E099E2BD6DB9E,$CBA2CBB9E0B9479C,$1D16B9BBB9180887
            Data.q $74B57ACA78AF5B4C,$AF6FF6D6DB37C751,$0100E6600000D4FE,$41F1591216256A02,$7C49499FA3297BD6
            Data.q $A27382A1E7FE5464,$800B2D867FF37278,$FB3A3FAE9EC5C3A9,$15023EE6E7D7B5DC,$7CBEB77F9249BD7D
            Data.q $B4425CCA8A3EE4E4,$341B193C8A925140,$76DA360D8E66AC16,$05E47E6CDCF068D5,$C1F9E0A547CCE3CF
            Data.q $F5B4F15DB2307868,$72DC8CE6DED461CA,$0000143E86C1FBBD,$6C1350428FF0634C,$2347FA1C767FB6C5
            Data.q $F17FFA212F726C3E,$CFC5C3CBBCD5162C,$E5B93AA771B2DB5C,$C6620003CBF293B5,$7F9783EEEB7A6D8E
            Data.q $3D0A4A2C23EE5CAF,$8B091E7C8AFDC145,$7A5508FB9D0FBD92,$3EE561D2FA54306C,$B19EA187DC92A314
            Data.q $F51FAE551F3BAAC1,$821F9BB9621DCF06,$F7270AEF73C14D78,$AE0F0CCDDCED7A64,$73D1F6B609FDD65A
            Data.q $2040CC0000183F15,$5D7BF8FB38CD4040,$8954382B2895FECE,$D1A2888BA3EF30F0,$D1A9E0D5D2EBBC82
            Data.q $26002CB60EFE9BA3,$0303CEE96FA67507,$A11F73654502085F,$EE6C8BD746747DCE,$0FB9D86CBE325023
            Data.q $F2EB3430FB9FC6A9,$B73C11D476B99441,$A8ED7479E0EC3F37,$C0F424669F773C1E,$74E118B1BB9E09A0
            Data.q $FEE7FDBB476DF5E3,$18D30000060FE1AC,$A55BEDEC33501008,$EB13A7467077F2EB,$F7E920F3A47C5A55
            Data.q $5F2FE1C343E2A2C5,$003E5B53FC274ABA,$3DEEFA871300165B,$357434BE8667B1EE,$5146BC11F729579C
            Data.q $9EAD68A3EE7CB4B8,$7728F888D1F722B7,$D577FF6BBB5728FD,$9B9E0EDD0566E782,$E7E7824A382341E1
            Data.q $937095CB2297B918,$B2D12EB95EB1B9D0,$5613DAEECABF1DA5,$3FC10330000070FD,$DA875B15B05D4100
            Data.q $62B7CA1B38CF5B38,$7915297E2A20B365,$F0A978BBCD2283BD,$B53FDA786E379737,$2ECC0024F9C9EEF9
            Data.q $C7DCD544F9EDCD2E,$987DCF558FC14922,$8FDDBC8FB9AD472B,$936E70BBC706C65A,$A00EDCF06F18FD77
            Data.q $1E76BC78FBE782A7,$5DA58AD5EB2CAFDB,$1F69BF7FB6AB179F,$A0201019A600000E,$E8DADBC76DEAD86E
            Data.q $441FAF8CE07FFA9D,$D0F0911D1187ABE9,$8DAE88482C686BFF,$F86A7858B85F57C8,$EB400596C2CFC6C8
            Data.q $181F4F4DF1B63B18,$E0A2BB47DCC548F8,$3B23EE58D67C8A4D,$4F58363B992A1836,$6B647EB96A16A3EE
            Data.q $E092AF373C119B77,$5B73B598844881F9,$E5CE39CEA30EB878,$A4FFEA3FFF6BAF1B,$0D01008073300000
            Data.q $F8731D2FFED8AEE1,$88588657ADA5101F,$2AE4A9291099C510,$F4BF060C0D122C52,$6BFCD89FE53AA0D2
            Data.q $4D0024DFFC3E91EA,$200000D8E1782144,$BCDD1D5441444900,$FB9AAC5F2BC1F770,$1F73C69CC14959F8
            Data.q $AF23F5C66C1B1ECD,$FCB18773C159AAED,$CED668383D29F9E0,$2B55A30E388C449D,$EE38BD6E56CA3EBA
            Data.q $63FC18D30000070F,$DB8FEDB95F0C340F,$7D2A52BDE6CFFE3D,$EB0F0ACAC76320F9,$E97BAF20415FA222
            Data.q $13D85E5C5F5FD8FC,$404D00165B04DA9C,$A5F234BC4FC7D23D,$C28A5DC11F7B2AC1,$72A64C047DCB6A5B
            Data.q $0FB931318112C51F,$E782C6A20FD7EAA2,$322E7831AC171EDC,$17CF076BB95373C1,$DBF8B0E3B7B6D8DC
            Data.q $204CCC0000209FDA,$05AEF22230C34040,$1081EF6FDB2E17EF,$C5F151019D87C565,$ABE16BD5D7D2CA44
            Data.q $9B83A1A9EC79785E,$3EB269BA6F4EA73E,$DF85BDCB8133001B,$1F72E5BDF0ECF33F,$57705259B828A861
            Data.q $43EE54AA508FB9ED,$272342C47DCD5512,$E7823347CBECD1F7,$F773C1AD49444F2E,$624480CA3CF0696C
            Data.q $3AFC74B7A5A20844,$00018BFB9956FB7B,$760B8C0402022CC0,$877AD5DB3A4637D7,$2148ECABE6E98BB1
            Data.q $C2BF4AC36D878465,$F73C5FB1A5FCE890,$A1BF2DB1D8C4E152,$80129FB93B8F7BBE,$1C761BF3727047E9
            Data.q $C9E047DCA578FC1C,$47DCD951107DC909,$3D596A3E21D4EFEA,$783E5E305CF0666F,$C79E0D2FEEE4605E
            Data.q $BFAED2C568CE2BD6,$0407F351DF6E56F7,$371808040C198000,$9BB876742F6BF7AC,$958EDA79FEDF2318
            Data.q $C4A2B241E69562B5,$AFED74BDCF75E5F7,$F37A7074F5D1D87E,$50DD3001F3EB26EB,$CBF07FB9DFCFD627
            Data.q $48CFC7DCC5792F81,$D0DE31F736263A0A,$A78C7B9E08AD1E79,$7B9E0EDD0076E782,$ABBCF072B07B938C
            Data.q $CDA3FDB73F981DD3,$0081FD300000B4F9,$3DE3EAFEAC414D01,$FC957EC64483E2DD,$8A58CDD9107CB999
            Data.q $CFEC9059D97A328A,$67AAF050E0D1528A,$2FC6DF70627B5DCE,$01E3E1270B7D23A8,$E0C5E67444506D30
            Data.q $1F731545FC57830B,$91F72F23EF7DAAAF,$1FBF11F723AC171A,$67FB2ABD9CAAF587,$773C1ED7DE88C8B6
            Data.q $92B32F773C14D588,$72BE782A7970B9E0,$00000E78201FE759,$B6AB7869A0201009,$9F79B4F8974F6DFD
            Data.q $3D922983E2C561B5,$4561B52AC96357D1,$A2458496BA3162AF,$87E733C2FE8C2F97,$CB605FF4D91C8D8F
            Data.q $EEFC36FB2B9F2002,$CC3EE5E40FC3B389,$78FC14926E0ABFFF,$1F7295231187DCF9,$CD898E88979DACD2
            Data.q $05AC5F8F3C1AD47D,$649C773C1D3773C1,$3C11BBED8DE1707C,$A9A0201034800007,$F7F9DA7343E72BB4
            Data.q $122C886CE9BC95D3,$B2EC91316A4551A9,$89088D7A6AF30B47,$617D9DD78A168EBE,$2704F73AF05F2FE4
            Data.q $4C00A4FBC9FAF6DE,$6079DEEF9B53FC3D,$4208FB9F984193E0,$C8515FB829238149,$43582A3C47DCD955
            Data.q $B18AD0D0646F23EE,$E09B9FD91FAF5AC1,$0B9E0CE3E38263B9,$DCF042B062E7828A,$0001CF0422C97265
            Data.q $8EEC2A6808040B20,$C79B4B6F0EDCFEAD,$8C8C5886E783B39E,$B52202D48A4BC911,$C5152572C48A4884
            Data.q $8AA43FD154A2AC56,$3B8287972416BDFA,$0FBD8183F2BD9C4F,$98165B0CDD1D517D,$D0F7B75E0F83A8F5
            Data.q $7DCD96E57C172FE5,$351FAFA9D1F73A04,$41F72468E88C3EE6,$FD7ED472C1B1FE34,$B9E0A3F5DCF07E68
            Data.q $0FF9DADF9E0854EB,$0189F79ABB6DAADE,$CE9A020100666000,$9D55C98799DECFFF,$6ABD5BDEE73DFE67
            Data.q $424B521210240217,$318D8EC6362D9902,$789C670B0DA0C05E,$CE09E66719D671E2,$F1E38CEC78E3C438
            Data.q $ED893899C59C6493,$804919178C9C7138,$D0240231B1836C57,$F524204842010BBE,$CE3F99CE5DD556AA
            Data.q $557556EB7B9EF739,$9EA7E7EFA2F57577,$BDE73F1BB75D5BDE,$7A70DAEB1FBEF7EF,$CD06C38ED5D6D4F6
            Data.q $05ECB6F35E7AECFB,$4002C424DA203764,$ABD357911707D1CC,$7011849044A2B347,$73E5F076BFF395FC
            Data.q $CB1A7DFBADF70707,$FCFF16E85E642E22,$85A1E73882D299DA,$295C20408FDC6847,$CCEA21F73FAC2E11
            Data.q $18D094C1B2D68C7D,$CF1B6A9188DCF061,$CECE7768EF3C1247,$041209EBABEF70EE,$0546210090205C41
            Data.q $FE5A33D98EC364B6,$9AE95863501E7D93,$220EA73C84AAF95E,$5E5A620097202672,$CE462D22FBF96F35
            Data.q $D5FFF7CFC3D4C497,$5BED78707B7DA731,$BFD118C41349ECC6,$26BFD23BEDEFCD6B,$012CC1211687DF77
            Data.q $F735A8FBED91E6FF,$2AF46D51F73E3401,$18D08DCF04B579FB,$BF5773C16AF3C6CE,$9B55D8C7EA70B25C
            Data.q $2E20820924F5D6CE,$B2CB46A310804810,$CEFFCB567B35BFFB,$92F101258ADC58FB,$1E6212E1807D0204
            Data.q $C5199916884B1620,$849844F6F9AA5E4A,$877DEAFF5E99C491,$A77FAACCFD3B1FFA,$F77C3FC142E22CB1
            Data.q $CD2373F67B3C4FB5,$8FB9D9A3EFB3D47D,$FCAC06FC8FDC952C,$C3BB9E0C860739E0,$86F9E0A99C3B9E08
            Data.q $82082493D11E5F8D,$F69546210090C498,$77DE698CC4FA6D6F,$0895FA58CD25F7EC,$E353040232022F90
            Data.q $3CC4254B101DA21E,$48C5B0FDC151FE3D,$83CBE2F021044914,$BD81C1DCEC77DFEF,$4664C45963423F6B
            Data.q $86EF5F6BB9D5581E,$642447DCEC151F92,$E4EA608156F1F73A,$CD98485B29647DC8,$8DCF04CF321D307E
            Data.q $E78264EE782D51FB,$2FCF0443B3F3C6F1,$39E0A053ECCFFB6D,$A310804805441041,$5F8529F4C414FB0A
            Data.q $88DC7DE40E7368ED,$244654C790945910,$425ABA2248B9B075,$48DECAEC4371CACC,$A9ACB69848C2B61D
            Data.q $B6D651DCFFEB9F07,$8CF79A5BDEFC3833,$8FF85AF4BC79A209,$C3EBB65C5C56BCAF,$EC225CB840A10E37
            Data.q $5401F730135723D2,$39F373C1F9007ECF,$9BBD5C484EC47C46,$F1BAA8E0963B9E0E,$7C7417CF1B10FB7C
            Data.q $249FBAB6E374B0B9,$6210090405C41041,$BB325DF4368B61D4,$B0318C7D65D72EED,$27D90042654481CC
            Data.q $021B950C8B264F21,$4B9621285A225708,$FA20BB6203B6AD44,$D9C4A184FEB565B0,$BE8FDDFDAEF97F1E
            Data.q $311658D3AFAEF5BA,$1F7687CD7BB73899,$A650823A71BF7BEA,$F0134FE0207E1F72,$9709899F0E09597F
            Data.q $A8C0B61FB3F200FB,$5DCF06C8FDC635F4,$376E6026E78372C9,$3BB8319773C1D961,$4BBB79E08870BC39
            Data.q $048086208209CF1B,$2E470DE2D814D108,$8258F2A39EBEDB9F,$F12ACF21293C8094,$B444A765FA21B891
            Data.q $1C4DB5DD42BA2242,$32611EB237B77D10,$FC1E5EC712841282,$BBD81E1FF42FDD95,$4596340DDB7223E6
            Data.q $B2DB2ED6874A684C,$1BFEADA11ADFECE3,$25DB820407DCE910,$E11F72655EB74742,$7A91FB89007DCB04
            Data.q $2A15E8C9BBB59D5F,$85E782CBCE3DCF06,$729E783A48F70E1E,$47DCA68B65861C3F,$0121A188208273C1
            Data.q $2F87FEEBAF0D3442,$05CCA18CA3F5B4BB,$C66EA0E4254791B1,$E8F521D2244BB242,$2C8E68897AE88952
            Data.q $44576920BB620FDB,$FFD43BEE7518B062,$AC0E0CED177D23B9,$891A209BCF59A5BB,$6F81A1DF617B7C3C
            Data.q $8F1DA159ED462F9E,$74C1122DE1128622,$E626823EE4E476ED,$9BBB5B863E2B863E,$CCE78261B11B9E0D
            Data.q $8725773C6E351FB8,$5863C6EE783CADBB,$9BF5BA7B69CC971C,$04104A27AC32BE9B,$ED2A688402418171
            Data.q $FEB517C5E5FF362B,$9648F4AC71A8001B,$E250200438038A54,$4F1F07D111DB4843,$B511275E8892EA22
            Data.q $6A70AEE4A2B14665,$2FE3D33F5EA05B11,$AF4F53D1F7BFBEDF,$5C18EE7EB83CBAFA,$3F759EAF36188206
            Data.q $3EBBDA57E72BF2F7,$BFBDDFD40823EE4C,$F2CF8604AA5FC044,$268D1F7313511F73,$EED76E783CAAEDBF
            Data.q $C1B3776A6E782B72,$E1C65DCF1BE50773,$7E7822199EE0C8BD,$04104E782987DB71,$6333A68840241B51
            Data.q $55B615A7335BF0B0,$A4021E4249644273,$D74A6F4B1C6A6400,$EB1643768A622263,$CB21A66FEEE6B8BB
            Data.q $E07C7A39108C4576,$7BB0383EEA1C7657,$7A9A17D77B977FED,$7DDFF71418620811,$7DCE97BFDD7DF6E7
            Data.q $D14FE0207EDF7F24,$721A823EE44357AD,$803EE566ABD1D91F,$A150DD9D5DCF04C6,$648E1FB8DCF074F3
            Data.q $0920F3C6D979C0A9,$5F3C1B376ABABB9E,$53F765858BF3B0BC,$804846A208209CF0,$E978A1BCDD874D10
            Data.q $7315E716D6DAC2EC,$00FA48252462309C,$EBA70AC3A50EBCF9,$AE70890B3838ACD1,$349112F08106F044
            Data.q $DF16C65E23C25963,$B9D462C1B7075635,$7FA57E1C5FEF70E7,$5AFB36B7BDF0707B,$3EE6AB03C8AD4410
            Data.q $EE6CFC973FF4E3B5,$4B77C204CE7ADAC3,$21F733AABD6EAE84,$1F72BA8A508FB932,$9CF04918D51F128D
            Data.q $DCF04993DCF07103,$B870F6F73C18AF03,$D59F3C13957235BE,$0820944FE1BC7CE6,$5813188402431262
            Data.q $EB5D6F2E0BE3C6D7,$0EF2C0C1E12BE670,$CC40E492BC012716,$610DED622E3557DD,$DC11255D1120A212
            Data.q $567A4785A4761028,$D9DAF22129B83EDE,$2BC9FD9EF667F2D2,$65F564794DF5DD4F,$29F905510420BF4D
            Data.q $840DF5AFFDC783F0,$A1847CE30FB9B3B3,$1DB94B3F84937044,$0D748ABF1987E766,$3847DCAC21F7366F
            Data.q $70C7C448CD87DCC2,$3818CE73C16A8FDC,$80EE782B5DDAE967,$60F70601DDCF06E5,$65725F3C1B3772BA
            Data.q $5104104E7829C7E7,$DAEBC3318840241F,$7399FF1D85A2E4F4,$011CC47E2C203966,$418427687BED0BD0
            Data.q $A87323627755B1DF,$44837A224D344482,$56C43BED6F074CB8,$E8E442D242E55D28,$FEC0EF7679EEE74B
            Data.q $88B2C690FFAB5DBE,$DCF87F55EAF742F1,$C92F472906B7038B,$58205F3F8081047D,$B93110B488FB9F99
            Data.q $AD55E8C90AF4788F,$3868C7DCB5430FB9,$7EEE5039E0F5401F,$1B561776AA79E098,$F3C1B9E07B9E0E96
            Data.q $CF061C7105CAB3C2,$CCCE7CF049BBB533,$CA8E2FBC7BED3DD6,$0090C49882082593,$B2BE9B65B694C621
            Data.q $7B2C11EDE7FB5E70,$007B901200318B14,$884A1F1695F8F494,$43EAB423D521D168,$2E88965FC204CBC3
            Data.q $8490694D74B1C7B3,$45830207E2216DD2,$3C1D9FFF50E7B9D1,$31B6F6B43833B7D1,$9BBAF0FF01043CBC
            Data.q $71103F69FB3CEEB6,$024EB2AE78D995CB,$110F849B78449B61,$60449888FB930C0B,$73F0D83D3BD486C4
            Data.q $DCA1848D5E8CB51F,$72EDEA1911B6F30F,$9E0CE3DCF05AA3F7,$CABEEE78215E76D9,$70FF953CF0E49EE0
            Data.q $163F713C387FCAB8,$140D9EECAFFB6BCC,$201213A88208273C,$39DEE150F53398C4,$18CA2C3A611F5AB3
            Data.q $6EC010B083CE90C0,$888744A64888B6A4,$13F2D32C9192B1C7,$051BC11215822415,$90B9D3D287114E82
            Data.q $F59DAF0284122172,$4F13A3FBD5DD6D97,$937E7EB73E41B9DE,$EA7EB73E40410B2F,$0DD2F92F5FBD3DF6
            Data.q $43F090FB9DB9C0E3,$3F768B7E02EDFF01,$575F2BA6EC3EE490,$947DC88DBB95DAEF,$BBB54A8FDC834E7D
            Data.q $39E0ED776B95DBC9,$52B773C132AE1BB7,$1D16B8DB78305CF0,$797858FF9595EB56,$90DA7F1B65BDB7C7
            Data.q $0241817104104B27,$BCC41B3DD8731884,$CA3BD3B537DEDA8B,$BD307958B246A018,$0C3A81079D3EC01F
            Data.q $272920B9692C7199,$49BD112698F50A44,$BCECF6B842AE5822,$DE4393F7C442D879,$B39EECFBDEE763D1
            Data.q $CB1A23F9AF76FB7B,$E3FDCE274BC99A22,$518463520B4A676B,$1275C102041BB7F2,$FBEF61EDD93265E1
            Data.q $C98D572350FB90A8,$3CC05AAAF472347D,$8645ABAEED6CEDEF,$895074BD09339E09,$F6F9592BAEED6C8B
            Data.q $763339EE1F72A673,$6D68FDC61FBDE3C5,$2307FADD992F0671,$243017104104B27A,$FA70DAEB01718840
            Data.q $341F0285D585058A,$AF2172B0221623A2,$885766B5FD3E7802,$BE60A016E884E6AC,$C38232CF1AAB7040
            Data.q $1BEFD024427922B8,$D9FBDFDAEE751F38,$FBDF870776FA27FD,$C0C505C448B931CE,$57EFA87DDC1F35DE
            Data.q $E70264B32B0FBED4,$0EBD782047304081,$88FB93957CDD739C,$B2B51A87DCACE31B,$BB511A3EE6D8C605
            Data.q $C153C203B1213B1B,$6D4C57EDD0F59573,$8B7AAA6B88CE373C,$3EFB35DCAACAF9BA,$D967E76174B1FB8C
            Data.q $820984F446C70DA2,$86E3108048602E20,$CECAEAB9EC0F4596,$A79C000F8B5C380F,$380CC3B0319C2173
            Data.q $1F1189F3EA46BEAD,$0213B44471242759,$022DE0893AF5963D,$D920BB4FDF0914C1,$4B4A67D3ACD1EDD7
            Data.q $BCB62787E671DE9E,$E28B4622CB1A7EE7,$B7FDD1DE9E4B5581,$298671D2F5564089,$21129DE0895D0814
            Data.q $E5979CB64887EED7,$107958015DCAAC3E,$4E6CBD6000FB9651,$838DDDA9231AA3EE,$EAE2C0773C1D2CE7
            Data.q $57E357005582335D,$BCF0E5D72C11AACF,$399901CAE1D77EA4,$69FFCF4CF3A17BCD,$909C98820827B3CE
            Data.q $DA6D572D15C62100,$E279C5FFD4E164B8,$C013B606592DD880,$EBAF25628CDD7AA0,$EE6042BBC47E9503
            Data.q $B7C204D3C4BBEB0A,$279BCD5278462508,$773C4A106FE0EC44,$F7F767DDB6DD706C,$688B2C683FFB5CEF
            Data.q $C5A3C1C2FAEF7224,$DFCCC33B0C1B9FAF,$29C1B2F408FB9C5D,$882A1E39686EDD49,$4211F72B023EE49E
            Data.q $D84C8728D5876E58,$347DCAD1861F12DC,$53C0F73C1B3776BA,$C383FE74EDE6BBB5,$2BA6EB897850C33D
            Data.q $1628D43E2D3C3825,$EDBD97B94C5795C7,$882082613D11C5A7,$EA63B8C420121C0B,$CDF6BCFE727F36EB
            Data.q $62587CEC69D0AB9C,$AF920B00AD802104,$651E94D92C7FE693,$0501B74427624AC6,$E126DC102058224C
            Data.q $F252216C42674FCF,$3E773931DAFDE4A3,$8EFB33E7A071DF6A,$B1EEFB581E2DEEF7,$F160D4E2E4C45EBA
            Data.q $BEEC7D78313A5ECF,$8932E10178A4B959,$0DDCAAC302264BB0,$1EC21F73661C8C90,$28BC1552AF46B2C7
            Data.q $72A135628D947DCF,$DB9E0D9BBB5EA817,$DCF04CB0325CBBB5,$ED7947CC92C78303,$3C250E88CDBB832E
            Data.q $B4BF2E19C3B9E0EC,$B51E6FF7A596E1FD,$0240817104104C27,$E34E970030771884,$13CE1ECB4668B81F
            Data.q $79F6F31CB1C661D1,$C4376388FFCBDB00,$418DD3211F66DE0A,$DE0DE61505048C5A,$38F501B9134E1026
            Data.q $2FEDDD3ACC699BF4,$796F2FFBE7ABB6DE,$11658D1D6FB926CF,$DD9FBBCD7078A6C3,$EF38C1A2F6FBFDD3
            Data.q $E8B7FC053B26FE61,$90DDCAE87DC9B9C0,$0C90FB9341E2D48B,$DE31CF42F1BB9565,$3BBF5DAEED6F51F7
            Data.q $76B679E0A56EED54,$6BD7833CFB8703D7,$58F3DCF0749DCE05,$309F88EF738E6738,$9F18840241041041
            Data.q $B7857E5C0E0F65B0,$9C000E6B39CDBDB6,$D8014FD3874462D9,$12F1E8097129B28F,$BFCCCB1DBCBD41B5
            Data.q $25D3048CE515119B,$BCF809D7F849B782,$2372A4443728885C,$79ADCF17B9EB31A6,$FE6B5DFEC1CF40FA
            Data.q $BA88B2C69DBE1E58,$EF476DB25FD77B90,$CD323A76AED55557,$BA1125DF08108157,$42B315F35610FDDA
            Data.q $B9CD652847DC99E6,$65A33C1F73B3430F,$56EDD31F26EED52A,$E78366EED4CAB9BA,$5532FC78C7AEED76
            Data.q $55D8D43BB8321BBB,$76575DE782647CEC,$77A37D81EBA5A17C,$80481C2E20820805,$B91E0FC5D696E310
            Data.q $7184C38EF5F4C966,$D8184471886C9242,$3EA43DFF9CBC0611,$B3B74C6F62411944,$A852F827F64CA121
            Data.q $81120BF80977ACB1,$29169233948F8B11,$4FDEFEC775A8C583,$FBBC1E2DED1A3BEF,$0122E2622F5E668E
            Data.q $FE7DDD6BE0657E1C,$861BB9526EDD749C,$EDDA45FE12CDE112,$772A6E7C261F72B0,$AB547DC9EA3EFBB3
            Data.q $FBCB51FBB469B5DC,$E783679009B9E0EC,$6DE3C63DCF05481C,$E0787ECE961371E7,$A4178717770E3028
            Data.q $8E8670E576330F9D,$C4727CE94CF4F776,$024000820820984F,$C8FDBF4B78E71884,$6207EE55EF53A5CA
            Data.q $C58E337501D1C417,$91648AE51EB033B6,$23D4CBA709888E30,$87D4C6A48730FA64,$DC10275C1022D040
            Data.q $9F33110B4B4FE026,$FDD504C44713F25F,$3B6DE2FEB3B5E040,$80F3DE27E5F77ECF,$311BAFB3417EB03C
            Data.q $BF0F0FE6BEDDE8B1,$B5DC6E6C2A5B7FD0,$2BF80997F9608D40,$75523EE74B20E8F5,$FB9D886E30F9DAD3
            Data.q $6A8FB959B772A5A8,$3776A951FBB657A3,$3F76C1BFFF8F3C1B,$EC1E2CE78F73C132,$6D572BD6E90F7067
            Data.q $4BE782A21163773D,$CF736EBB18F94E17,$8001041041349F88,$F366BCE801310804,$71938BFE7616BBE7
            Data.q $16D83A1CC4264C41,$9090F88C69BA1500,$8B58F57A6A150210,$0867F115DA0487CE,$3BE028DC1026DE94
            Data.q $6C910894B155F8C9,$DCEC72390FECDD50,$63BBDFD99DF7A7AA,$EA6D6FAC4F94FFF5,$6FBB81FE04262385
            Data.q $BB95DB4F99D76A7C,$255AFBF48C2AF9A6,$E794529A25EA77C2,$3EFBC60F178C843E,$698485987DCB2CB8
            Data.q $ADEA3547DCFCD1D1,$D22EED54F3C135DD,$33EE1CE78395BBB5,$0F08C3D713C39E0C,$5B65BB3C5D5FB547
            Data.q $349F54657E36B7EB,$6210090605C41041,$325CEFEB47717042,$4904620B3B69EDA7,$260127F0312F4A1C
            Data.q $53243E22402133CA,$CC43B99628F15923,$98B1464CA4447284,$D28142FE0262CD1E,$F32C36E9458205BB
            Data.q $62C190F9DBAA0ED2,$EBEC9FEF40F3BAD4,$66CEF6BFDC5DDDEF,$EFAEF722FC623B5F,$2892A5EBF7B075DC
            Data.q $0A1BB95245772BA4,$81FBB45BF0176FF8,$3EE79530CA87DCF2,$D12CAF478A779584,$EED5468FB959A591
            Data.q $93CBBD531DCF05E6,$38CBB9E0F283B9D0,$5CF05557DC1997BC,$E073C150F0891F39,$2CAA7D95FF6D79F2
            Data.q $12008C4104104322,$77E0D8AD8084C420,$B71DEA9F4ED6F5CD,$06111DA21B94699B,$BC9AFA8CF6066EF0
            Data.q $4112238C3E236E3F,$85DC3995F8D6203B,$021F3C0754B36EE6,$0EF4A05EBFC04141,$87E91E9C36466081
            Data.q $EB3B5E43E6CACB1A,$4FE3A1E7ABBADE2F,$CD95F7743C90F9DC,$E0DF44E4F8C47EBC,$B75DB1715AF2BCDF
            Data.q $568C6711EF2A841B,$E561E324CB97844A,$930D9C6B37FD223E,$C4476ED8745A10FB,$180AF46F23EE5964
            Data.q $35DDADEA3547DCDD,$DAAA475DDABCF3C1,$5C44712C7888E35D,$D87C77A33E0D97A9,$3BF395F9E0ADCF5B
            Data.q $7D51C9F1B5D0B5FF,$40242017104104D2,$E589E0F65B030988,$C4A8AC782EEF535D,$8063086ED8343A87
            Data.q $CAC96E9CF38322F3,$2312A441671B7BB9,$5A994A121DDE2192,$3742F6E02040185E,$9409B7F80866442D
            Data.q $09BA70F2F128146E,$773C94E310F9DBAC,$EDEF7776A7CEE06C,$C2EB2C684FE6B9DD,$7AFB1D9ADD6FB4A5
            Data.q $41B15606EE57643F,$EA378205B3044A18,$59A48C9BF93C8365,$BB4AF47B0F1DA9AA,$07DCA78F1DFF527A
            Data.q $ED6431265DDAF8D0,$DDCB35BA20BB63AE,$3A6F4F3C1916E0CF,$177D3AB6B6EED4CF,$104D2790D7DEB5B5
            Data.q $284C420120A44104,$67AB86FA7FEE4B0A,$65F88E7028398EFC,$930053B00B3C884A,$4252447C44F4B179
            Data.q $FABC4248E49B43E8,$88448F88EE5A1710,$0A5704098940A494,$DE7AB2ACB1A977F8,$8C58372859887C9C
            Data.q $7A7B9FF9EFEE775A,$59634DDFF716F67B,$EE4FB9FAE0F21817,$DDCA9868464FF33A,$8205C049DFF19230
            Data.q $72C21FBB5C844977,$259772A95044983D,$BD55E8EC8FB937EF,$3D776BB460D18FB9,$FB1E1699776BF3C6
            Data.q $B1FBB4DCF0F9CA78,$AF0D8AD867C74164,$30B882082055EE8C,$6F96DA384C420121,$6A65FEA6BA6BD7FA
            Data.q $E22118D734939859,$59A9BB9307C0C13C,$9BA6B788E4977EA4,$0B50E65DD520486C,$E357084CE2462312
            Data.q $374A04F250292559,$081FBAC0A877F808,$E33258AB146A4A94,$74E4C2D1179D3258,$7A1F675DD6E57FB7
            Data.q $D56478B77C7717E9,$00902C62495EE6E2,$387F5F5AFFEF1D0E,$8C23F6491EF38C33,$B5530448B7901EF4
            Data.q $D8825A1BB95391FB,$86EE55965215DCAE,$47EE1A31F7288C52,$9E0E3776A5ABEF2D,$EED6C9208D776A67
            Data.q $5CB047A9DDC392BA,$330CE41D2CCBCF0E,$DD7FF9B4A64779A6,$41944104104D2790,$F2DA3CCC90988402
            Data.q $4B8CD8FFB59705D1,$FC03E675EB7481C4,$9A833A50A9160631,$2242E4C3E231B713,$42236936C9042258
            Data.q $1096C0C38F4C1D02,$11F5E9486CA9A7F1,$7921F3B7501D377C,$63B1DE0D2FA3F5C1,$4D3EAB1DEEEEC0E7
            Data.q $3EAB1DFE9B935963,$79B0ED5B8185E472,$97F014AF772A6618,$3A06EE54C92E548A,$B95391F72B3011EB
            Data.q $DE47DC938D5F8F1B,$9AEED6E1B1FD95E8,$DC187B776B9AAC26,$A785FFFD4AE9A6A3,$4F9795EEED4CAF5B
            Data.q $13C86FDF7D7597B9,$420120CA20820827,$19C2C41B3DD8484C,$088C472D19ECFD7C,$33F48C58ACB1AD71
            Data.q $4393CE0CF1925B38,$322112D0ACB24D8C,$9DD526F25E30B4BD,$C442C442F84990E7,$04AB4A050B59A337
            Data.q $1B295460D5228B4A,$1FDF40FBB596D392,$76B03A5FDDEDEEEF,$0FF15462585C98D5,$9ACF9E8ECB76B9AD
            Data.q $FD230ABE6AC0DDCA,$D89BAADE1026D0B7,$B8E2D3246EE57958,$FB94AE5BF9AEE552,$EE4A8951F7233430
            Data.q $A67AEED6C6B1F264,$AA2ED370FBECD776,$D6E3FADC5DE619C3,$82713EA8CEFFEEAB,$84C420121C0B8820
            Data.q $A74B55CF6EFCAD85,$FC6B1CFB7368EEAE,$312FBD95C774CCCA,$AA5EBE620B963DB0,$88F0B4422C435ECA
            Data.q $D2BB9322116CB25B,$884CA21F440754BE,$34A11EDFA80E9E04,$9CDD884E32C5193D,$82D2EE99CA046415
            Data.q $77E7EC703CF677A7,$89F20F26B2C69F7C,$C97BFFF40E7BADF5,$EE574A28DDCAE28F,$E9EF84877C204286
            Data.q $079C6EE57B5133BF,$5EB0007DCED942D1,$B347DCBCD92B31EA,$E3DD776A21BD776A,$B870FBEC9E69EE0C
            Data.q $5E163CF118943F76,$081573A3BDCB6972,$4262100903082082,$99AFEBBEFF75D2D3,$731039F965CF01FE
            Data.q $2C2F5C7383277367,$21A65ACE9539CDD4,$04092C474C36644B,$412910B947C462DB,$6E940A77FD0C4BC4
            Data.q $459880ED2CB6928A,$1E8E442DAF6D7686,$BB7B035DF6F77C1F,$2BC049ACB1A1AC77,$5E5A55389C5FFCEC
            Data.q $7D6E70895AF772B5,$23EE4C8F9EF1BB95,$AC6187C5A4057A3B,$D6E18FF9CA81772A,$6C9B3EEED5433AEE
            Data.q $F163F718546FB73A,$67B4DE2CB72FCE82,$0E05C41041389FD4,$E36CBAD3C2621009,$278709FE98AC3783
            Data.q $8D9BD5C2C1F6DD73,$3966B557AC0CE3F9,$760CB1C7CBC370E6,$8C5B4287D0F53D38,$0917F04425221354
            Data.q $CB192225FC05ABF8,$0392442D245713F2,$9E81D76151F3F9E9,$6FB4B073D3D3DE3F,$1441A25A5F269ADD
            Data.q $BFDDFDF6F779AE0F,$5DCA921BEEE56437,$8C5772A2183070B3,$FBAF579F2D6EE561,$3C6EED6E18AE3EA1
            Data.q $DC39FB7AEED56582,$1D72BC6ADCE9B5A2,$FC875667A7368E86,$188208209C4F4D44,$6BD4C14988402411
            Data.q $DB7CA68B65D3FC1F,$D0A4B36346CC3D76,$72C94E0C23CE0C11,$854A287D9103AC41,$5245628D621B8DD3
            Data.q $DF5666D43B98C78D,$56B8F494884CA297,$A5021DD658D48BC9,$41EA02A217265199,$7BA7020415A63E58
            Data.q $EC74DEEEEF4FF9FC,$34DDDCF8BF7C77E7,$D9CD574790813596,$572B207EABF7A3B6,$5772A667782042EE
            Data.q $7FD03772AB223EE7,$32A3772B15148163,$A3E23D6EE55F51D1,$93074BB216A37E52,$5DDA9C31FBB4ABD1
            Data.q $CCBEEEBBB5D88CE3,$8EC2D75E8B4CC1C2,$27EC3D3A1F4B613F,$10090CD441041044,$7FC2D65C00C05262
            Data.q $0A8E39775A8B92FD,$077065D7101D6699,$61CDC6E78863F819,$2A2F19484A31D2A5,$9838AC919B28EFB4
            Data.q $0B6EA43AD73BAC2E,$5B7494232F349291,$46A44E8A118DF156,$DBCDEDAEDD2874B1,$6FB7BBE0F8F4722B
            Data.q $E467F57DB3DBDEEF,$FA898D799BDABBB6,$7753FC18BE8E0091,$4B2FEEE56AA73F9F,$98DFF1BB95D2D304
            Data.q $42D7421F726BB955,$2D4B23A2DAEE55E7,$C983A59EA48DBB95,$AA6BC0F5DDAFC3EB,$3872BE6E87EE55DD
            Data.q $FE3C51D4396F4E66,$104104104AEF477F,$F1BB034988402436,$DA9EAFB6166BC1A1,$6E5AB3C3C2369EE9
            Data.q $55B3830AF395C8CC,$4874C67082E30F89,$0EDD404C6C45713D,$87A6092CEA02A7A5,$A825221191E12A4C
            Data.q $205918948B12DF0A,$E8A11A5A502D5A50,$72C8A54A114B140B,$3DEFAADF2CD19244,$8FFEF60F3B0A8A5F
            Data.q $5EEFFB4BFB8AA73D,$EEC0C1D44CCBE4D7,$559DFF68E07BBF35,$51D797F010AF772B,$FA584DDA65166BB9
            Data.q $18FDC5ADDCAACD63,$DDDADCB1875DDA8B,$51DC6BBB553C0BC2,$03F8EB2F0B0DFFF3,$209E4F4D6133E376
            Data.q $4988402431188208,$62B4BF0BF36ABB05,$374DDBE61696FAD6,$C0C038C11E26E5A6,$9B13BAC7105DA48F
            Data.q $07158E3659058EDB,$0EC70A0ED0A1F583,$4422D2328A442588,$9B6A8DFE02B96637,$F655E7A5093B3FBA
            Data.q $7AFBE8605E28FC96,$FC7C5FFBD9D76B2C,$36325DAFF7161F8E,$65DAD0E944A89C57,$1BB95339F33F6E4F
            Data.q $DBE1022DBB953945,$6999080C95DCABEB,$547DC9F8C605B2B9,$B48FAED5776AAC62,$FB697E5C526E6A33
            Data.q $5CD104104BBB54C3,$6FAAEF0E93108048,$2C6F719EAE97F4FF,$A670803EA9B0EC3E,$E256334DA73BA536
            Data.q $07323F1E6F3D7082,$2D9922162B1C7B26,$6514884F28C1A6D5,$0412ACA6E28CA284,$7A5029DE9422D34A
            Data.q $28B6BDB5D88ACA93,$FE7917ED60486E31,$BBBBDBDF6E77C1A5,$3BEBBDCACFEAC767,$FAEF723613AAE6C7
            Data.q $145F3F5F0343FEC2,$1BB95523EBB5A1ED,$7772B634B7E1F129,$4D957B7E401F73B4,$EBBB5CAB39776AA3
            Data.q $7C6678CD776BFAB0,$8299949CE165C243,$41444900200000CE,$13C9E9A83FBD8B54,$310804830D104104
            Data.q $B35C2F81F2B29929,$590D30F08D97DA6C,$8398FCA43EBAFC4E,$E5043E8E20BB4F9F,$CDD40748127A0E61
            Data.q $6423E6740AC71AC3,$EA03A9111D64845A,$E8574A11925EA83A,$9528FDD8A34B8625,$58D97F7937BEAB22
            Data.q $CF62F3DA3FDE81D6,$B5E66DEF7581D2DE,$F1CCFA583D39CA26,$A57772B55B5FCE57,$1A59BB95F1BF3844
            Data.q $7DEF3CF06918FB9D,$76A951FB8E55F8F1,$55763C6EED7943D7,$917CA62B92EEED63,$090F9A208209776A
            Data.q $87DB676972D26210,$65AD75C278EBCC17,$F120735421530E63,$970311B8331FDC19,$84C9AC1092086E50
            Data.q $27B52FA1CCB91DE4,$460D2652D43BEA44,$59D4A2910AC915DA,$2C7A51625EA82B10,$DA48AE30E9C4A2EB
            Data.q $53D658F4B4DAB111,$F9EFE7F1786ECE3B,$C57B9ACBDDE0E951,$DB2DDD607F380009,$4D0F381D88FD9CF6
            Data.q $BC10219DDCA9AEED,$54351FF3882E2931,$34057A33D5F79AEE,$ADDDADC30B51F726,$CEA75DDA9EB074B4
            Data.q $3D3593E29D19DDDA,$0090A1A208208229,$E97F06C56C2D2621,$CDC779A733B5B6C2,$E240E637CD33C3E1
            Data.q $6620F3CBC7AC31E8,$921F11884F6F2B2C,$1B882462521F0399,$84CA884A3E2C648C,$D50750B8B2511148
            Data.q $4223BE2ACB192C4B,$54A37B2BA5658F51,$E789420ACB1EC456,$3BDDDDD9EDBB9F8F,$D5963467F55F6ECF
            Data.q $EEEFB733F5DEE43C,$A6D50C3C9020F7F9,$78EDDA377FB430F3,$F5DABB9558E84487,$A998AF478DDCABC8
            Data.q $40BB95D9A06255D8,$8C3AEED6918FDD63,$8504C410412EED51,$9D378B61A9310804,$7C2DADD5D4E56EBA
            Data.q $E7A99E0735B875D0,$1D56A9E1EEE1C23D,$68F2A921CC4172C7,$35DA442649648496,$7622159DBBB92CAA
            Data.q $7E243E4C4264C446,$9A5C502D5C50882C,$C1F76B2C65AABF1E,$C1FEEF62F5DC3FBE,$40BF85EA69EE6BBD
            Data.q $29E99E3FC0CCF179,$DF772A655E8F4DCD,$F9DAEE574ACFE128,$3212BD19AEE56CA1,$137A6BB95791F7D9
            Data.q $27AABD188DE76DEC,$82663E61FB8F5E74,$F79AEED491FB89E7,$DDDAB28FDAEED5E5,$DAA105D8DDDAE91D
            Data.q $100901718820825D,$9BD9F9BC5853D262,$84DD079E1BF99FAE,$334FEA838F039E93,$576B2C6699655A15
            Data.q $599222B96EA33C48,$2C443A1450733E07,$EB94442591DB3B93,$564B4CB0C7A4A111,$22710894F5412589
            Data.q $9C508AAE2817AE94,$B6759638D48777AD,$7CDF3DDDB6D974A7,$F57874A4FFB767E1,$F6067A4C35FA31F2
            Data.q $B5EFFDC3DEE0F9AE,$2B8DDDAA81047CF7,$72BF0CD7F809E777,$B481772A723E7637,$1A30CAF4748C30F8
            Data.q $6CDC4498C7CD074B,$F1E983F718401765,$A9C90193020DD4C8,$CF5DDAA9679F75DD,$412EED51B6EED6CD
            Data.q $20B884024218C410,$3E5FAE37F36ABF68,$AEB879883C98FFF3,$A70E51F7067086E5,$0BB61F6331D6693F
            Data.q $A12E9C261F118792,$B09BA6B7A024B1C6,$424A903ED5C844B1,$90F93130B12116C4,$08B7FC053BFE02A9
            Data.q $8625ECB2C7A1DD14,$F67767D6FE7CBC2F,$58D05FD57DBB3F6F,$A782CD7FBF396356,$D8F11420DBFD9FB7
            Data.q $86AA07E221291455,$56CD50EF84482C37,$1A94D772BA18E9CA,$B41D2C91DDCA844C,$BBB5DA0E96D52133
            Data.q $776BABAEED59781E,$386E657EDDAEDD4D,$104BBB544DDDDAA8,$182E210090863104,$CEC2D75F72DF3F66
            Data.q $327842251079D81F,$C270E7DFB830119E,$1BB120B899569DCC,$88B5537A11DFE152,$4E15330F0A85526B
            Data.q $59A3311096960F8F,$90F9B9EA82B110B1,$45971408D694222B,$22B94B2C6A51FA28,$96359018D5F11896
            Data.q $70707DDF3E77DFF5,$B49FE5E2695FDADF,$F834BFCFE7AD6FC8,$E76DBCCEA3E773D5,$94DA08136FF88446
            Data.q $0AEE5543576330F0,$EED59181772BCC60,$5ED776A9583A5A56,$134192CD776A683A,$32E20B8D776BB73A
            Data.q $78163755DDAACF0E,$209776A8F3D776AA,$60B88402403C6208,$7CEF2E8B106CF760,$C3F762872D599CDF
            Data.q $CFD392DC5658F163,$DC7A587E1F44FEE0,$A0F5D32CD0E991C3,$3788F34507548459,$B90915DA3763DBA6
            Data.q $19BAEA8DAD2E92DE,$4EBA5089C43E6AAB,$C43E715963DAF6D5,$0BEEEACB1D98645A,$7FE7F5FDD5DB6EE6
            Data.q $7A32359634A3FB7E,$2DF06C7A391F4ABB,$72A1873AEA1F3DE9,$2A1542E112E5C243,$8EEE577C615E8D4F
            Data.q $0E97A181074B6A94,$5DDAACF5DDAE9672,$7706087CEC65DFF3,$8BBBB5F99563D73B,$405C6208209776A9
            Data.q $F4368B60A0B88402,$B70E8EAEE3B4BD5D,$90DC6A809B87CCCF,$24CF78712FB830E5,$0B25BB73D9E2CD4B
            Data.q $1F11BB7CF6407FC9,$271A171663163580,$4A44265933F5CCC4,$1521F3B5EBAE5452,$785A5185E592B2C6
            Data.q $2DFCFC78BD658CE4,$EAB1DEECEEF4775B,$7703A53F55963473,$B6CC67CF676A7CAF,$1F884E341D2F40F3
            Data.q $F6EB37FC0453F808,$AD55C8D52BB9532B,$EE5418EEED71BB95,$5BCDDDA9A0E96B36,$0E96CA75DDAD983A
            Data.q $66BAF3DC1887B832,$25DDAA2CEEED42BB,$2E21009017188208,$95A6E8783D975A38,$3373C2E05783FEB3
            Data.q $6F6FD3C1432E1A23,$628F63AED3566157,$797ADCD568772471,$241FBC4440726F5D,$122172B3A50AC07E
            Data.q $6154A43E4E488564,$476A18A05CB4AB2C,$AEEE97DF2CB186A4,$E1CF42F1D91F7D03,$F268BEBFBDD7FBF3
            Data.q $91EF617B7C3C8B85,$8C8A2151F92F7FDE,$78C9DA460E96B0F0,$EDB323F76AE84487,$05B2BD1A56EE54DC
            Data.q $A5B54A47772BB346,$B531059DAEED7683,$B2DDDAD983A5D9BB,$AD5797B7833E83A5,$12EED52A70BA5DDD
            Data.q $17108048138C4104,$2B4DDEFFEFCBAD24,$4376241E52AC7D67,$B109C4B0CF70E51E,$2C991099D338B2C6
            Data.q $03AA4236594D3354,$88462316CB24765D,$9902442592ACD198,$CA55A2325897AA0E,$40A774A056BACB1B
            Data.q $D35452C521128E69,$9DD6C97FAF4F5658,$68FEDF9F85FDFF67,$A704359634DDF0E9,$7578A5789CCFDD7B
            Data.q $20408FCEF11D1190,$CCA22C939FC251B8,$5E8C43FF7E4DDCAB,$8D1F15C357A3F861,$E9BBB5B3C7D43F76
            Data.q $81E83A5DC81C83A5,$E0C65DDAED068B27,$38DCE04CC370E6EE,$5B48EF34C6619C9C,$18820825DDAA45F1
            Data.q $5DA6582E21009027,$8DF69AEEAFCFF9B7,$07E3C2D3CF10794A,$682D756187496E0C,$B0C7B1059264462C
            Data.q $61EB7DD9E242FBB2,$5973A5988C462172,$4885B105C4F3E221,$EB2C77243E714651,$188B7E022DFE021D
            Data.q $DFB6679D99D658C6,$FB9B53EDF0F257F5,$65BED7FB0418995B,$3020F3B6D4EEAEEB,$E08122EB047ABBB5
            Data.q $9BB95532E73A1D7A,$54C842EF7FA311DA,$ADDCABCABD19AEE5,$D074B50CD9AAF477,$C1D163074B50CE7C
            Data.q $5BBB565E71E90394,$BD28C6491EE1C738,$B8EF2E8B1CA385B2,$0FC6208209776A8F,$F2E006160B884024
            Data.q $367F6DCF971BFE36,$770E3C176F31607B,$6CBC13C3987BC390,$23240E2307D5C42C,$4266C96560393259
            Data.q $B6D7EDD90F5D9204,$1F2F244253200910,$EAD2847975963B92,$F774BE97E2B2C7DA,$83C2871DFDFFEC1C
            Data.q $AC71F1B5F9AEF7E7,$667D4FB7C3C81F1D,$6438F040FD57EF7F,$3BC1E76D995DB56E,$772BAE76DE2CEFD4
            Data.q $5F1F07DCA9E76DED,$8CC7CC3F748DBB95,$BB3776B67C4461FB,$CA462242C06E3074,$76A1525BB5DBE7C2
            Data.q $B55CB78F2DC5EE77,$82082081174D6369,$761A0B8840240A68,$3D5CEE2CD78343E3,$E59E1FB8DA7BAA6D
            Data.q $F70655F772599886,$4354F38F107EF489,$FEF2B0C7B75B9996,$6940EA6223D61303,$A0488462311B76EE
            Data.q $980910B146494885,$63B9BDB5D887CDCC,$CB1F2E2E94097759,$BD3D2338CF526D4A,$F9ED7CF7775B25FE
            Data.q $ABEADCF4AC78EEC7,$8A7CBCC7198BF69B,$95B20B4A676BCDFF,$44B37F3B6D6461BB,$7AE5990DDCA92D30
            Data.q $AAC172B88F3B6CE4,$7DF882616902EE55,$4AC1D2F68C7DCF8D,$341D2F61FBB6BBB5,$CD3DC383F769BC35
            Data.q $88F9CA79E1CCBEE0,$39DCC0BBB5C68B17,$CE3104104BBB542D,$8DAEB0F05C420120,$2D2DB58CDD7A6FC7
            Data.q $D8399E7A1497B7DC,$D7EEE1CBDBC43728,$A40EAE58A339E7B3,$2133CA0767993CBB,$F488F8B52E9EDA80
            Data.q $6512216D501F52EB,$4AE4788D89604884,$C7F288BD55C5658F,$ACB1E9B7F808A6B2,$FC95658F61FBB4D6
            Data.q $B7C189D8EB2C6CA8,$566799FB77B67D6C,$7F537A66BEDC8DFD,$766B75BED288E341,$EA1BB95DA0FDEFEC
            Data.q $FE0265F9DB78DDCA,$772A1A8B9DB6FA8A,$3387772A834684CB,$AEED7683A5C8D5B6,$72C0741D2ECDD8A9
            Data.q $ED54B2CFB8320E96,$7982C7EE34A719AE,$FD74FCDD2C28DF9D,$484D188208208557,$C7A6E96F00041080
            Data.q $E943670FECFD74DF,$C9ED5D702851CB9E,$3FABA93DC39C7850,$BDE8E58A337539AD,$4CF2807E5A4B0E20
            Data.q $382350B6AEE48008,$7B32C119890448A1,$1D7561D929108C23,$EC90FEF621F3B754,$D48CBCE11979D658
            Data.q $52810AD2812AD658,$B1D9EA8265963E54,$FDF70E7BBA4952AC,$EFBF3FEDCE271DB7,$F25FD77B92CB1BC2
            Data.q $1AEE56CA5F33AED4,$BC20577C040FC3F7,$C79DB6FAF3215A4D,$8F52CDDCAC4DBB75,$4BD20E83A588D1FB
            Data.q $4983A5D93B9DED07,$E1EBC18C7B872EED,$B02850C38E5763B9,$117586FBBC53C5E2,$0804855188208208
            Data.q $EBE5F4DEAE3A6841,$70EE943642FB4F96,$0A39CB871E0A4825,$BC4F035406F0E43F,$AAC19C4E0FA65989
            Data.q $DAB5CEE6108CADEC,$8C5B120B114A10FB,$A292585659888564,$6BDB53105C6EA82C,$B1E99144980F536F
            Data.q $658EB58625A9D7AC,$5B25FEBD3D7AE599,$FF6F4FE8ED7CF577,$72FCA6CAED707FB9,$A7A97C0D4E4701C6
            Data.q $F64511E16A1D9C2F,$5F0936F5823D41E2,$65ADDCAE91F73B6F,$9DB62C64C2D0B9DB,$1D2D4359E3BD4AD7
            Data.q $B074B4AAB51932E4,$A8D43BB8305776AC,$861D44CBDA50EC55,$78DF2D9E7CA60B25,$8C4104104827EEAC
            Data.q $2992E2C20840243A,$7667F3BF395EF7ED,$5CF1D07C58F3DD28,$F50DC180FC0E76A6,$AC90E81477A158DD
            Data.q $C678AE1F16108B1B,$F11BD35D2C11B111,$19E4BBA852848C44,$43E75B55B3201221,$963B2B2DA68645EC
            Data.q $9D8A116452D16BE5,$5963FD5B7ACB1A91,$7577A7E6FF3C9D2F,$58FD26BBD9FA733F,$48E079BFB5AEDF56
            Data.q $92BF1AAEE5769DDF,$3B48B844976EE549,$47CEDBF9A078461E,$FDD7AF3C12463E22,$7B5DDA99E41D2EC8
            Data.q $EF0632E58ADDA0E9,$EC7B0F5C4C5B8700,$69E9EEED1D0CE1CA,$410410BA6A67FE1D,$1610420121D34410
            Data.q $772982D97F06C56C,$55D2849638519ECF,$67E673D559DD4416,$37120F38F18F0A38,$E58A3342C2F4B0F5
            Data.q $7DA44477CB18039A,$13C9208D7A2AB480,$D31289301EAC2622,$15658CC43E56BCF5,$354965B596F6D491
            Data.q $5D5D65B74CBC559A,$6DFFFD43DED658FF,$FB5FEFCF0703CBE7,$9AF0F15658E3271F,$BAE2AFE671DA9F2B
            Data.q $048446BB95C450DD,$DB3735D55BC102ED,$DB7336EE549943CE,$EF9020E96D5058F9,$C83A5A6B776B647E
            Data.q $3A5D558FBBB62554,$F7D75927E74575D8,$88208208197C9AFB,$D75819104201211A,$B6AEED3D5FD7D386
            Data.q $1079D95E8CD06756,$9B3DE0CC3F4B6CD7,$CB3478DADDCC41E4,$6BE5E3701262C51A,$A48211DE2592272A
            Data.q $4884648677B42B25,$3E7622162291119C,$EF32CB1ED7B6AF24,$74EBE284797B6B8B,$8A54AB2C6492E43E
            Data.q $6CE60BEEEACB1C86,$F1DD8FA3D5FDD9DD,$77FB36D7DDF0FF0B,$9F87E7AD6FC85A36,$4619D860C0DAFC1B
            Data.q $DDCAE23EE7576EBA,$EE54990586EE5548,$BD77B5DCAEC4076A,$668F9DB67ADDCA98,$7D51074B8A302EE5
            Data.q $6AE4A0E967AF20E9,$AF55D27712C460E9,$40E17A6B31C2312B,$1042E9AC5FDD6BFB,$8210090263104104
            Data.q $AF9BAED374B0A1C8,$B0E3DCF871EBF59F,$E29EF0E11195111D,$AF357620F24B1C28,$4F0988F5C15C18C7
            Data.q $9C4EA94B19984F46,$13110835BD55310B,$719658CC43E6CF54,$5FD11DD8ACB1EC43,$CB193DBFE08CEC5B
            Data.q $0C4EB2C7218FDDB2,$3F4F5B338EF4FCDE,$775658C3276FEAB3,$E6E0717B9E8FF157,$44A11F72A79C0AD0
            Data.q $863F76AE60893AF8,$E499095E8F6E76D8,$679F9C8B9DB6F23E,$A0E96A18D51F72AC,$C03BA0E9748C7EED
            Data.q $9AEED493AE83A5E2,$E3BCB82C30E3B9E0,$8241D2D29FB6F63E,$A88210090C718820,$6BA5FEDF4D8AFB40
            Data.q $4292F61C11A9FE66,$F428623FB002B5CF,$E20F3CA2E20F38F0,$279C20BB6E9024B0,$42E74B19AB010B8B
            Data.q $0910B62312C45762,$87C991FBB1221690,$19C65963B37B6B64,$CB19CFC95658CE19,$1C0F8FDB7BF7DC3A
            Data.q $A0CFC707ED77BF3E,$65BF5DD787F87D50,$6C91D129864FD9FB,$7F809A7F01430F3A,$9B9DB695BB95D0D3
            Data.q $7EED2073B6DE79D0,$0E9734648D1F7364,$FB96BA218CC3A71A,$2E2BC39E83A59C31,$975B4FEB49779C1D
            Data.q $08208797C1B07C6D,$0AA2084024306882,$9A2D9727E0F3BEB3,$2AC7692B14649DF2,$7DFB870414844A78
            Data.q $2059483C88694286,$FD6219DE300FF93D,$9A11E6EBD4CA42DB,$52442DBA0EFAED3B,$EC43E56E94265863
            Data.q $658CCDEDA9A2DEDA,$7596358E8BD4DBD9,$8D621F2A5658FE69,$EEEEB7B307F6F565,$8996FB7A7FE7E7FE
            Data.q $C775A5BD1F259636,$8B10A28B15AF9EDE,$247E0207E1F72B0F,$DCA8EA70224BBE10,$C63E2D2073B6C11D
            Data.q $D964C1D2F431FB8B,$74B4D47EE332FC60,$ED1F7684F70635F0,$E97132E83A59963C,$6208209074B4ADC5
            Data.q $E310400FF58EE002,$AFE75CF90829F619,$B8B57E5E5BF9F6F6,$84001EA1290E4A5C,$4248FC403E8BAF50
            Data.q $00FA106050B5C5DE,$0520CE4A443A9825,$38048418046B878F,$4803A2D3C9002007,$18CE73DDCC6DD387
            Data.q $C91C0952600D9342,$C1200700A4203820,$90BB4C2021201821,$88E0797BFA97B59E,$84A48860175F8B18
            Data.q $EE129D44302238C7,$419A788013851C2D,$90910CB85D9FAA0C,$4248A219210E1C88,$FA5775485A877508
            Data.q $F8B5789D37F3C9D8,$8E45C3FD776DA9CC,$FAD19EE6DD7671F3,$F67CA6DB578A357D,$3679E0E3CB3381F8
            Data.q $67F0906F840A11F7,$48846C5A46EE5795,$9BB55D80794CAE5A,$ACCD57A3D32E76DA,$5DCEDE61FBA91DDC
            Data.q $B41D2D9476F7A83A,$7EF7B41D2E2B762A,$AE3F719BA0E97CA0,$CF8DAE856FF9DF9C,$31882082083174D6
            Data.q $68B6021882101C85,$3B3BAB1DE5F2DF43,$39139C7A50BC9EDC,$41470050C13EE1CE,$8A3B343AAB5C41E7
            Data.q $9693CE00387F9A65,$43243CC4076C3CAC,$88CAC0915C63CE3C,$B6AF243E6C9FB198,$AF99658ECF536CD7
            Data.q $571422F38BD4DB31,$F719658C935D2847,$23FEF8205658EAA3,$9F0FFA9799E5FFFD,$F7E353F243E6B7DB
            Data.q $96EB7B581FCE7BFF,$AA613A38DF7FA71D,$FF0962F09089577A,$CC0DDCAE915D7D7A,$7CD076E76D855638
            Data.q $5B635A32B5BB95A4,$A47EE79DBD4AF466,$2F83A5CC36720E97,$B6B60E9795BD7830,$F86F1F60CD178338
            Data.q $7185462082082493,$E2EB44F18820087B,$F3EF19BAF1BC8F07,$AA9E0BD285E45C0A,$31AB0EF0E0EC2DEA
            Data.q $24F7B544225482AC,$CB147A071DE37777,$4A3FFCA03642C991,$32C86EC3CC888AE3,$488C99578F50D907
            Data.q $5963B243E56592DC,$F65765963374F6F6,$6571408E4AB2C766,$8F659632AA559632,$7B387F5F40BEF966
            Data.q $77D6F23A7F9EAEDB,$FDE6FAEEBC3FC2FF,$D4F9D5581E436B06,$0C23C6740E7FEEF6,$C4A04157633073D5
            Data.q $2A65CBB75D4EFF86,$57A351B772AD51F7,$EC3F708D16152336,$8E83A59C8FDCA5F7,$738C1D2D2B10C648
            Data.q $E4EEE0C860E9661F,$178B83A5F29E2ED6,$11F1C0FC5B35FC74,$9069A20820820C5D,$F36ABD691A882100
            Data.q $284D47C676BA6FC3,$871EE94266F2555D,$DD2876EAF35328F7,$D6C856BBBB98FB34,$CB487D1059C7A40E
            Data.q $1964374886B03EC3,$887C992213CFC457,$4C3C237536DE76FD,$3BD7992C322CDD60,$F0156FF0116F1423
            Data.q $BD5DC1CCB2DBCBDB,$DFCE274BC884A51E,$BADB5F5BDD33D4F4,$F79B33F5DEE5EFEA,$737F85AF8BCEAC5B
            Data.q $F7A40BEFBE714CEA,$608116F1FF24C87E,$95B2593BD7F615AA,$2AAF46A79DB695BB,$A355EB5BC61AEE54
            Data.q $A0E9672322C60E96,$FEED507211623F71,$694C3383F71C9C70,$D86D9F916B4D4F77,$121D462082082493
            Data.q $F07DAF5307510420,$53666FFA9B2E572F,$51C674A1323E72BA,$C7A5093E77873EF8,$39AF3574F5BE1D0F
            Data.q $1596A59258A3C58C,$3119A40ECAB2C766,$88439D7CB3C66612,$1B3839BAA0EB7137,$A2AB919AF6D76131
            Data.q $ACB1EBA8378ACB1E,$2845775963D88458,$00EAF92ACB1FCCAD,$88295338CCB2C66F,$91CCFBBFBDC39EF8
            Data.q $639BF75BEDCF07B3,$5BDDE6BBDC55963D,$2C461F1190FD9E77,$C2240BF6024C8105,$E56C8FB9D9FAEA15
            Data.q $FB8E186E76DE78EE,$EED43F7257E7CB51,$C4B70E4A0E963A8F,$BA2E0E9755E3EDE0,$B50383D96C13E3B2
            Data.q $407C620820820F5C,$F1D632E4EA208402,$29BB3A7F6BCC575B,$F7C7C5A2138CF3DD,$07EC9A235C564375
            Data.q $19CB9628F620F3B1,$B105CA1E35DC911C,$074446712213CF5F,$7F76487CE22603A0,$8F6EA6DBCA251988
            Data.q $4D75963B2422C565,$58F4DCD2816AE284,$4090F9E54488E256,$338EF4FD982FA7A0,$0FF16D77E6F43A5F
            Data.q $B906977F33637DDC,$3FCCF5B67FD33DEB,$02855E8CC3E2B295,$47DF7CADBFC24161,$B7AE31301BB95398
            Data.q $C3F71EAAF4648F9D,$0E979A8FDDB41D2C,$A0E9648A0E96A632,$B3345E0E964DDFAA,$CA8CAF9E95FDAFB0
            Data.q $6A0D462082082245,$286F37613A8822C1,$B7F01DEEEEEBC3CA,$4955C5312E0EED9E,$E438A792C16A963B
            Data.q $EEA64870B70A04CF,$438C7B7CEEA94B7A,$5C600182596DC440,$158E5D2C36E95735,$93A2332C7DEA20BB
            Data.q $24899AB49D7CC046,$2DE6E99061D52922,$8D5724192E467EA6,$B3EFD20D1ADC1255,$BF3D2CD6E81CB2DA
            Data.q $121D596D32B41AAF,$AD851293DC395BD1,$F357217BFD40621C,$DF488E09112391FA,$4E97860B66EF8EBD
            Data.q $5EA7C553C9FD7F9E,$FF3A78BE5F3DEA79,$6DFFD1E9D0FA5B38,$D9D4EEFE8E9C8E2A,$17DF0F30F8ACDCD2
            Data.q $7DB28AB41025DFF0,$772A73E8DB37211F,$68D5EB5ABCEDBE51,$A91FF295291F3B6F,$AC1A683A5AD283A5
            Data.q $D2C9E31185DDA990,$1850C65C4772C741,$E964BD70639F70E0,$ACBFCE0E97A6E7A0,$41D2D21FD2D80FED
            Data.q $0420390609882082,$BFAFE3C6D7580C31,$76BBEE1696DAE676,$FB0A3975DD7ADD10,$1E54F0051C3DBC39
            Data.q $658A3D883CE995C4,$D39B90C82EB374AA,$20919B3A09244763,$6598D3111DB04193,$9658C46905C621F2
            Data.q $1EA2845778A0573F,$D6484EDBA5B7B2CB,$FFD83EEF82FA2911,$EF6E7FD81DED4FDB,$EEE0D658C66EDF9A
            Data.q $3B7EFB3F6CB6EBB5,$F41E2D408F0B12A3,$F7B135D48BF80A97,$6E2B26087DCA547D,$BF4A8F8948A50F3B
            Data.q $69557A3071EDF8C7,$3A5D9146BF8F20E9,$C4E5F7B41D2C2BC8,$B872570DBFEB1019,$C5E0E969525BB53B
            Data.q $3507F9BA5D6E3F6D,$415C62082082105D,$E36BA14986208402,$5098EFF671BA6F93,$5A5AAF4554B1E7BA
            Data.q $D9D09EE0CE3DE1C8,$1079D2C788C4A910,$9628F1038422264F,$E30ADE8AD54845AB,$16F12212DD407158
            Data.q $CEC1864CB31BA475,$844D74AB2C623487,$52C508DCE2811AE2,$488565648EC90F92,$FE676DF1FB386F77
            Data.q $707F94F1DE1BCF71,$AF0F2877EB47EBCD,$DF7BFD5E27A3FD9F,$7E120411F16DF7FA,$421578D576F840AB
            Data.q $55B8F4E0252324A2,$4BC7CEDB51A3EE5E,$CEBF61FBA3502EE5,$B289339DFF439674,$D83A5B28FDC683A5
            Data.q $FB8D1AC6A4BEE0CD,$01ADFF50FDCA3AE1,$513CA8DF72D25E97,$420121D462082082,$B97FA6C573A02310
            Data.q $9987EC9BCFF4C561,$51C382DEAAACF755,$674A1790378701F8,$2D81CC41E54F0570,$42CD523E25020DDE
            Data.q $D87ACBCC78C18739,$B3D504C4424A8319,$B69541EA6DBC90F9,$B52ACB6D9BE7532C,$409B74A055BD2847
            Data.q $92BF61CC43E54DA9,$D8E05F7C11F92910,$96F4E5B23E37F389,$5DE0F24BE7BCB797,$EF5CF3DBFBFD1BB3
            Data.q $0E8B639A533A9E3F,$F80A77F3E1C433F3,$B8588FD9332089AD,$D02EE563C63EE4E5,$F11265DDAEC3F778
            Data.q $61FB82B7012640D2,$B8B05773D6CDCEFE,$96E3074B587E3AAA,$F3058670EBBB5D39,$8208241D2D1FFE3A
            Data.q $721188210090B898,$7CE82F177BB6B1F1,$6850599E0BD284C4,$1430EFBC380C2D2D,$BB3D6D84DD2874C2
            Data.q $DE5A997108890815,$21183D72AEE4CAE6,$58C9602442EAB112,$6D4CB2C6B74E1C56,$C66211295963AD6F
            Data.q $5E2816AE28152EB2,$1096596D5A18A11B,$04962810B65A2331,$ADB23E6FCF4F767F,$A8DBBFB5EEFF60F7
            Data.q $E5BFDFAB5D81ACB1,$7024B0D192EB33D9,$14AFF016AFE4871E,$3EFB0A81FB264408,$05DCA857A1B64CB8
            Data.q $E536BB95BF1CBD60,$87EE260E96F3CF9B,$2B51E38EFE683A59,$337A61C3A230FDCB,$2BA7B8324E3F71BA
            Data.q $A9E2FF70296C1D2F,$C0988208241D2D2E,$67BB0846209D0850,$7F7F5F7AEF079083,$87195D2B5F2753CB
            Data.q $247BB7E858A04DD1,$A50F2AEF0A044FE4,$00A40094E0757183,$E00C11C25BD07418,$103E239909B48EEA
            Data.q $5087F9974C1B204A,$E9846BBD482218CE,$41DB7BFAEAC3A5EF,$2908339CF243A975,$4A5EA65DE60542E0
            Data.q $8D57EFD2218C3809,$863111C1D2855C4F,$9CB84A50F5012448,$A788331621C35C41,$2E1D48E76805F080
            Data.q $9C3A6FF573824723,$07E4CFD471C07381,$CFDFEAF17F8FE662,$FD4F0FF2DFB6FEBF,$9DFDC393E36BA170
            Data.q $7FDF03EE6AB03B9D,$CD523081254B6FE5,$1F16324610286157,$FC3E2556FF0914E1,$4884B2BD1EA39178
            Data.q $95CA8F79D983EFBC,$6ABD1A4D566365BB,$941D2F163E61FBA4,$85A11C3D71B49549,$FF388FDCB2AD1985
            Data.q $D8F0772FD0FDDB01,$B05A558EBBD530FD,$BF36ABB02FF68AF8,$C62082082215FF50,$A5B001A20840240B
            Data.q $7FBABD5FED2E9D0F,$C94A741037D2DA30,$8F21C58CD5110B61,$9084046F201B7202,$0EA1480E30418C10
            Data.q $BAFF0EAE0A419CF5,$99C1260961D4CA89,$743D5586EA529F6A,$0442332A1CCC7D96,$29FFD4B61AAC50FA
            Data.q $B11A6464D27283A8,$C988EC1DF4886484,$588D2565B4D53EB8,$6B9F792C10E49E12,$16F08676A2030AC4
            Data.q $7D8402D88324F709,$E019C9A0FA84884A,$F5E62316218C1CBA,$C0D8F47F5C0D8EE7,$C572FF1DF9F85E2F
            Data.q $D9ED65B4E1BEE71C,$C3334BBAD7A5F03F,$618D5CD0548C2250,$47BE10207E8385A9,$9102E423E2D2F022
            Data.q $B054B047A846C448,$B47772B2347DC93C,$DBC9BBB5315A8D5C,$3C95D074B247EE79,$B87EE30F595880C9
            Data.q $BC9AE83A5AD775FA,$D057833F6E0CF3C8,$6861D773B6D6BB75,$1E9FBAB7A67A756F,$0C34410410410B93
            Data.q $D572D1068822C11A,$B40FACDD74DE7B03,$60A42BBDBA509214,$42485F70656C8576,$C15C38C7A14166E9
            Data.q $40E483883CFCF1E1,$23542FF7A5633497,$28733A6856904595,$1EDD4DB4A90F94AE,$658F11097EB9F2CB
            Data.q $BCE43E565A63D0F9,$E08DAE2815CFAC09,$58A3252C5FDEA0DF,$D444E764A443B345,$3D6F8FE092F9D6E8
            Data.q $767C399E8FCDA1FD,$99D658CF52FFEAFB,$B99DB62FD0FAEF67,$5FC3E08797C30923,$B0811F172F2E0892
            Data.q $39E7438AC11E85AE,$B6CD8C744CA88FB9,$F75CEDE61FBA91F3,$E84705129884CAC3,$3B5079BB34963736
            Data.q $623074B652238C70,$8E8AF074B10E7770,$A2E9AD9D36ABB2CF,$201216E310410410,$FCDC6F965A40D104
            Data.q $CE8ADA97FF3395FA,$E5C1563374DC5DF5,$4744ADD0A388FC28,$947A82AE374A1321,$FE1D6B962B4C41E7
            Data.q $4C4625321EA44286,$410F9AAFB5DCC446,$4C840ACB69921F26,$4A4445596D502032,$020976F310F95884
            Data.q $7BFE089AFE702E25,$BD45E9EDA8574A05,$880AC9629088D0C8,$EEE81258BD405497,$7BBFE5F87E6FA7F5
            Data.q $BBADF7F19F5BC96C,$E6BBB9FE70EBA869,$741C55FF2F3BF37F,$9FC040FD114BD20F,$E2C47C5D5ADFE02A
            Data.q $F4788FB9DB9D0ACD,$6C2693BF651D12CA,$FE683A59C32E1F3B,$4B30FDC683A5ED36,$C485CAD390B31D07
            Data.q $F7267EB8720F074B,$EF14DA619C1FB261,$64FE1BE7C28194F8,$582343A688208209,$27E0F0DE6660D104
            Data.q $FB87BDCAFB763F97,$6A1EB325212948D7,$7C848EF880F84B34,$8F21216B4828871F,$041E6CC292F6A48F
            Data.q $B9C5674CC2942392,$BE50D0B4BC652110,$68CD0E0BC646D0AC,$CC043E49950F8896,$339221F38B02CB1A
            Data.q $2393942E59633984,$887CACB347A1FBCD,$C24DB0D48732D919,$9CFCE0C659C195BD,$E57E32616063E9C1
            Data.q $2B3086CA8325EA38,$9FFBB5FF48EFBF90,$CBFC77E1FFB2DBEB,$9436BACA3FD385B2,$FDE96E8F0049658D
            Data.q $080A106A7F5EEEE7,$9184491440A10401,$2056B044850ABD1A,$3711F10555CB7470,$8230F88CBD75715E
            Data.q $D79DB6347772AF23,$7CF96A3F71C3B5F2,$C0C9707EEDA0E97B,$87ECAC362580F08C,$DC19155E8F1E7AD9
            Data.q $C45B0FDDB429CAFD,$86C56C13FDBCBA2F,$31041041213FD0E2,$01860D10420121DE,$6C1FDDD03F3BB390
            Data.q $1059D3ABF9E4F979,$A040FE424E7E942B,$20000026ECB45C70,$E487275441444900,$92D9883CD9E94395
            Data.q $E82AD404AE20F26E,$64D561EC8676C5FC,$6611108AB6BE603E,$1510E4AE3EFEB5BB,$991DD804960BA9B6
            Data.q $D92423D4DB36FDDC,$03023501CC442311,$00BBE067ACE0C79F,$88963033E3831B67,$9B373EABED74C60E
            Data.q $07D4EC7FDF025297,$77ADA9CD667ADF1F,$B7B22F8181A2FC7E,$7753CAFD92DE34FD,$6D5BD1DFFECFDEFE
            Data.q $832F5430890911E1,$A92F38448B7C2040,$523E2598FE980DDA,$95EEF690F1C6578D,$6DD231F7FB0FB9EA
            Data.q $54990FDC4341A3E7,$3373F6F6369D9AED,$A8F6AFC6AE49E582,$ECAA2E8D45A72C11,$ECB4668B901D8F07
            Data.q $A2ECC75FF9B0DD69,$0804850D10410410,$E28186C56C028C41,$7AA783FBFBAB35E1,$D287621129D9C3FB
            Data.q $8009BE4016E4065F,$932780882E51C91E,$D687572C86AC3A50,$712B21BB30099DA1,$4963FA44ABF7CC41
            Data.q $237C5DCC442D96AB,$0380986032B92044,$1E32E4516AE596D5,$8B48935ED64565B7,$884A58C947A1010D
            Data.q $07D22CCC6A8C65A8,$8B3832D73833875B,$401521F8182FF819,$4A52FBBBE91F172F,$85E37D2FF4D14B14
            Data.q $EE0D6FCA78BE5BBF,$A2781EABF6E1FD5F,$E787FABFE2D56478,$648A23C227E4ACFF,$205B304491447EEC
            Data.q $DAED5491F1DED5BA,$5B223E25229023E2,$EA673AEA1F726478,$357A35A32F7E7376,$3F7355D7D2A3F75C
            Data.q $3A25AEED761F3DE2,$335F369AAE29D64C,$0E967370611EE0C0,$28F96B2FCBAC319A,$4104104D7D5554FB
            Data.q $D128C4108048204C,$DF6B03F9E8F9B5DA,$C94848FF4F27D3F7,$2C9692212C519225,$12258871170253B1
            Data.q $025B94C02D13C905,$0A4187699704DCAE,$4705D79ABB148B40,$698CC1BDC3E80108,$0969B56E58073165
            Data.q $42180110B9664398,$C45658ECDEDAB288,$754A57B6B8A3B693,$DD1C442D872ED538,$AC63FAE089EF6594
            Data.q $383057C0C5DE7013,$2800884AD3B0328F,$E04A58FAA4804073,$FDDDDB6ED73D3D99,$B6FF6FFADD36A78B
            Data.q $91EDFAF6CE9BE5E1,$2847EE587C461090,$1DB2AE02247BA204,$E55D8DE47C764C81,$AEE54E47DF788F89
            Data.q $350E1ABD1CCDDEB9,$2E740E1FB8CC1D2D,$0FDC6E58389AFAC9,$CF547AE8038AE9CB,$FBBB961C16FFA5DD
            Data.q $DD2EB48FAD25DE63,$104104C2795183FC,$91462084024098C4,$E6B9DDE91E9B65B6,$95291BFE9DB7C7DE
            Data.q $AA4212C3193210A0,$721CE98502A3C85C,$21953043F43A368E,$38C0A04043CA74F1,$8624695E8A92297C
            Data.q $5A9520BAAA03C4B4,$70EA2213C9188C98,$2C66BDB5D887CE9D,$11092B7B6BD591CB,$C2311B6F331FC406
            Data.q $1967F032AFCE01E6,$4A008844FCC038F0,$625575D44FEBD884,$74466BFE39DF9BE0,$B5D100943E762048
            Data.q $72C126E68890EFBA,$C3E239F882A482E3,$D1F72F23E24A8D08,$10891FBA46ABD1AC,$7BC42114C3F72961
            Data.q $0F5DA15D074B323E,$C36E85DEAE2B9728,$690AF0E31EE0CB3A,$4B80F3C462D5C3F7,$10428BB0D7DDB767
            Data.q $C41080480B8C4104,$FC7F3F9B75ED3328,$07CF7F63B75E7717,$95DFE943F321EB95,$D2872ADA21C2BF90
            Data.q $FB6567214964B03D,$F2B146A4550A9241,$8F948AEE51E61616,$24C5963D88856566,$671E1B5DA96C16F4
            Data.q $44265442243E4C48,$DD198D85A44F18CC,$7E8C3A676DDF4CE1,$DB0027E03197C003,$18960EE2C479F953
            Data.q $4878588948744A11,$F7924100B5738409,$2AEDA48B9C366108,$147A64AF1AA47C47,$A59EA16B772AAC6B
            Data.q $5C3F71851AFE3C83,$1D2F11FB8DD01B24,$6C2E7438C1D2C994,$A0E978B3B63F43E7,$60B0CE105D8B8A69
            Data.q $36DFEECB0A37E75E,$2B8C4104104C27E2,$BD37981344108048,$70BD9695E7BA77ED,$A1584292D4A6F07C
            Data.q $70D62027BE0492F4,$907952CE9427A9C0,$D202C51990616A50,$1EA4FAC1FC8656E3,$8105AFDE6C6F9B96
            Data.q $34F8CB2C6B0FDBB9,$C746AC19557536F6,$3880C22119EBF438,$EBCFF4C22BB4CEAC,$000EB08846ECBBE8
            Data.q $B00BBE031D7E00AB,$6EDA0CB8DA9FAD57,$81DE9120162FD730,$7A225C4401084912,$50F5C4B079F64CBF
            Data.q $2ABC6923E2D0C6AE,$D1A89CB635F11F17,$D6B99AA5A86E76DC,$83F73CF07EE4ABAF,$97996AE59E97B2B1
            Data.q $1C6BEE0C93DC382E,$B82861D776A7216E,$7AC3E3E14678BFDC,$0486B8C410410422,$2F8362B601344108
            Data.q $7ADC2E7FDB5BADF7,$29FA50C5597FACFA,$E765E35BC8063E40,$4A179E94D999D0EA,$147A755364DC8737
            Data.q $6A79F31B2C96A86B,$B704808884A64BB8,$CB19CAE569A121F2,$122129673843E6CA,$1FF24C9159A3C642
            Data.q $1197E34C462C4321,$5DFF00F98DBF4C24,$FD250061E0093C06,$50C2422791F16BB3,$6B44010874E54A42
            Data.q $720130E089A5C425,$106A2422511973F3,$AF3B6DFC71D7791F,$8FDD660E97B0FDD7,$D18F4BB7199766B8
            Data.q $1FBAE6EED4C3F769,$232BB1987EEC783B,$17C7616BA1875C42,$10C2ED368FFB92D8,$410804834D104104
            Data.q $C1FE2BE37CB60934,$84C799D4F63F7735,$F4A1E59109CAAD94,$2129588736721203,$D525B8960E98DA84
            Data.q $DAF355441E49E942,$4319B8D7BEA658A3,$F9F65E5E9AEC4365,$CE91E11A4221F3D5,$424442D8DCED7087
            Data.q $A570126029931109,$988846B055531F7E,$011BD8030185C697,$7ADA7C80BBE0035C,$484DEC6A00645A2E
            Data.q $F20285918B43E768,$F11F1132536350ED,$4F1F258462D315C8,$8FB950C7C5CAAC46,$B946ABD1C51E75D4
            Data.q $1A8704B71F7ADC1F,$DCA3F7EA566353B1,$C61C084A61FB3B2F,$DC383F7B3487DC92,$3F7197831F6E0CA3
            Data.q $7A6FA756D68FFECC,$1041089EB0CCFCBB,$4D10420121EE3104,$D67B03D3F374B0A4,$2955F6BD4F63CEFE
            Data.q $213C74A1E5101685,$D287AACBC8726620,$9240BA50EC3E2501,$B50A118884A17107,$5E3E4DE9AE56F2D7
            Data.q $921F2A47846EA83D,$C452937144224423,$5BB25B6AC8903ECC,$E989189401209496,$4DF007AF003EF004
            Data.q $AD59FE882E371E40,$AEA43F040B30BA50,$52840021E1132467,$8AED2C82C5A87240,$F5E76D878C7C448C
            Data.q $6BB0FDC663E61FB8,$ECE2AE1A62138D77,$E86DA9E0B87EE587,$1E2EEE0C12C6698E,$EAC06E91FB2A1F3B
            Data.q $D97374B659F9D05A,$4072620820824932,$9BD5E74C9A208402,$75B75EABADD5F5FE,$F53C1409488FD9E7
            Data.q $E400BA50E886E57E,$5DA629800F79010F,$6AEE943AE94D8869,$CB6C6691079B2067,$B346A1AD919B970A
            Data.q $43E7622175700392,$88C9888495BDB5B2,$A1D004CAE464C870,$1B50048252181B9E,$8F003EE00058CBB7
            Data.q $5D0874FC04936201,$16945C4001F79118,$AC0486C4B130B11E,$23E2CAABB6D9E70D,$EE9A3BB9559ADD7B
            Data.q $1DAB87EE317BFD87,$E244F06707DF788E,$887B8307EE65387E,$CE0FD97938312DC1,$FBDFA53E3BD3B530
            Data.q $62082082113D61EB,$3980C62084024042,$ABCEC2C9747CB7CF,$0B11AA677FED1E0F,$88490F1000821B89
            Data.q $98FBE7372E0A187B,$D57920FDD9E942A1,$E3B24875922BB6BC,$F388221255F7E958,$42622159BDB57921
            Data.q $8B622BB5CEAC26CC,$59FA994AF154C891,$4016EF9FF2DE16AC,$CACC78805BE000DC,$0DB8849571090882
            Data.q $EBB61EB3A1E15990,$3E2AD45C461FB261,$FAE72CEFF1E742F2,$C11E983F70D18336,$EDB240E9C620B38A
            Data.q $7773B6D528385E3C,$970FD9523EE54F0F,$1B15B24F8EFCF163,$4410410432BBCD8A,$BB006310420121B3
            Data.q $6FAFBCD7DB908367,$F38BF3D5E27ADC20,$0F9093EC8700E942,$8745A58ADD76F203,$DBD8DDD285AA4471
            Data.q $76B841E4D1E1F190,$E52A169402338628,$90442AAF541B2442,$622B89EBBBA96D34,$2C47FCAD5DF5118B
            Data.q $09D61CDD7DFEF242,$15F10965F88043E0,$3B7E2120B2002F00,$34843C2521921111,$66A3D222E2E55923
            Data.q $86BDC8F89AB557D0,$2D23F712357A3CA3,$3CB8301C3F7686E6,$8CA8B5074BC47EED,$FDDC18C20B8CAF5B
            Data.q $3846250FDD64844A,$FF75EEB5F6F0CF66,$98820820844F5865,$5D82318821009030,$BEEAF57874A7B9B7
            Data.q $5DAA60FEBE96C173,$7AC66A849C1AABCF,$C1DF5EBC015B9011,$2074A13D5628C967,$D6434CB147B1079D
            Data.q $7F493DDF20113950,$5B4322FAB7BABB1F,$188C8F99264C4488,$F125162002411201,$33327CD258E3D4B5
            Data.q $12DFF88025802B3F,$118E72122D101878,$F092A35768B9FA20,$F8BE5E7F103D73C8,$7EE50C2D6EE56668
            Data.q $7EF31C3F7287B798,$30FDCB0D8960C0C9,$B83183F72C1E57CD,$CF0FBEC983DC19E7,$FCC8858F0EBBAF55
            Data.q $6B50DF6F631F1D79,$2141310410411B59,$03D74B4863104201,$9F47D5FEEFFB8AFB,$C64897052901F57C
            Data.q $8848CF1111C480B1,$1E6DE8EA45850C59,$5B5B80EB70404982,$AF4D54320F2F3D28,$97203DCEDEB2E11A
            Data.q $3131E875416A910B,$DB893916912B90FB,$E679B3A559D7E321,$FA5DE203844C71FD,$248C5A44876E59F9
            Data.q $F539FD95C8FAA1C2,$FDD7AABD18D18F8A,$CCBCC3F71C8D0948,$1661FB94B25C1FBA,$3C713C63C3F71A0D
            Data.q $DABF1AB9279608F4,$9B9C0E978EE802A3,$BAD93CB517A5C7FC,$410428BB0D83E36C,$8C41080485B8C410
            Data.q $1DEE9DFFDD57AD31,$2D3F6733C4F93EAB,$47C96336E45C2025,$A9D7D53390033900,$019D4822C00E8505
            Data.q $183107979E9435A9,$7566F5A169772367,$C598D4AA8D1E9231,$464C89CE311D95A4,$D620BB16323D22C6
            Data.q $5277FE2333FD39C1,$9854468CFF61B168,$E162F3E61E3B63E7,$E250DE7ECFEFD321,$F77C80AF5BB34B23
            Data.q $F716B6D7B273EF23,$F1E744150FDC6783,$1CFB831CE40762FB,$5D8D5C1F7DE9EB83,$DCD970C38E83A599
            Data.q $208209A4F61AFBD6,$820853FA1F0D7188,$AE9FE0FB5FA66D18,$A68CCF05DBF53258,$E1C7DEA97A9E7830
            Data.q $EEAF828621EF0E09,$F5703C85DAA0172E,$677D4A1039A5FA60,$024A9B6AB56EEA1A,$D59BD77278B366C2
            Data.q $7D801FA642087FF5,$6876F5A1EB0E4F48,$5324FD8B54A10939,$975E4887EC2157E3,$026BFA0460CE8112
            Data.q $D7C04F3FA1301026,$1D7D49CF987AD08F,$3CE713BFF4F346CC,$A87AE522943D0074,$57A319A3E2FD7A20
            Data.q $DC660E97723F7523,$B8C81FBB1C93530F,$900EC991D0EFFA1F,$E7F4BBB8724AFDB8,$FD085575C3F7693B
            Data.q $FD36BAF03F6DB9F2,$4C4104104227AEAC,$030071882101C858,$6DA4BEEF5F9CDB20,$F481D32B8393F1C9
            Data.q $04F7E425E7910DC4,$2B74C1D72438AB0A,$E942152473A60E94,$E4E7A50A97FE5EA1,$E375413D7920E241
            Data.q $0172B4C4477CB052,$9B6FD0EAC2622389,$C47BC92B4464A991,$8467743B6B296D07,$66FF50EDD67AFD81
            Data.q $FAFB288E7CDCC879,$72555E8C58C7C5FA,$34C3F7255D7D2A3F,$16A5F88DDC48B95D,$872C11AD70FDC61B
            Data.q $CCBC8BEE0C3DB831,$59E2E283E59370FD,$202E2082083F7205,$F8DD8138C4108048,$73FEAEEEB7DCA0D0
            Data.q $66BCECC1BD3D33C1,$00BF0049E439212C,$83F78AA11E232FE4,$5A8D9ED4AF47A148,$6A1422483CD9E942
            Data.q $428D6E155603A40F,$8FBE623169381124,$CCC448F0B614462D,$FA9618C9EBD48850,$66C9CF9986B932DE
            Data.q $E1806E22ABEF523D,$BB54ADE6AED18F8B,$B531AFACC1FB8B5B,$945B73A13375C6BA,$30E8953B6DBB52B8
            Data.q $19C20B89E5CF73A1,$4DD2C28DFED65C16,$1041041389F546BB,$608E310420120AE3,$FBBDAFF60B1E37CB
            Data.q $48594848FF4FA791,$BB592D58420CE942,$414499621C45E425,$012746A8095E1AAA,$74A1EAF4B6F42608
            Data.q $EB8CDF7A98976D0E,$C9019D2CE0D7EF61,$724511084335F652,$BDB2BAFE88C44FB0,$ACF1AFC87D910C1F
            Data.q $70B61FB24C2BEF6E,$E5EA492E79FCFF48,$70D18F89668F7910,$57661A11B9B0EC3F,$EDC697ACC1FB994B
            Data.q $0635F70E0FEEF690,$61D074B79B8724F7,$89FBA678BC2CB828,$E131041041389EBA,$ABBC338C41080CA1
            Data.q $9BDE661BE6ECFD36,$E0B4BEBB0F562DDC,$77264E14318FB871,$DCCBC18416710BA1,$C1BBB322A6AD7691
            Data.q $20F25572E5E241E4,$3D50080CEC0CE4F5,$C92C7F2A2FE49223,$D46ACAA421F88882,$19BFECDAF93210F2
            Data.q $2CF2CAC7F956FFC6,$FDC5A83347C4F472,$F264272683459200,$31BBF9BD636A1C43,$252FD0AEE571437F
            Data.q $EC7A55C8CC3B1E4B,$5F9D05CAE15E8F4A,$20E5C18E8F9B5D66,$04201210C6208208,$B85F03F572990E31
            Data.q $1C472E7B2FB4F976,$21F851C1D286CF4C,$3E87D671DF506147,$755A4F4307374A13,$42A51AB4DD2856A8
            Data.q $3D6B83D9211728E9,$84644382B2442AD4,$61F1A9289978F981,$723A28AEF7DE4D7F,$C7C470C7BCA54784
            Data.q $91FBA4689559AD50,$366EBF61FBB5AEFC,$3F7691265D7AEB9D,$C7EEC47E2C65D08C,$75DCADCF0CF70649
            Data.q $AB5670671696861D,$082082713D7527FB,$4E31045823405262,$C3F33DC3FDB53B99,$2F6A73781C5F4765
            Data.q $977C42517A50AC08,$0E94255380E3AC41,$BA50AA1617A60101,$509E94DED55AAA90,$C3CAC51B6A074A1E
            Data.q $BE1DE6F956CACF1E,$BDFF959E335EDA93,$E3EF3FDFB3B7F9EA,$37E4039FD0E5D7A9,$524B86699D93D55D
            Data.q $1FB994571F50FDCD,$E264AB466B95B8D6,$15EB4C8AEBA1187E,$87EEDB384A9DDC18,$F8E8AF8B582D26EB
            Data.q $E4FEA32BE37CB66B,$1009077188208209,$797C1B15B0A71882,$E9FB7F3EDEDAFD78,$284E48276A65FEB3
            Data.q $EA6DE4051F2034FD,$3D2854897A8730FD,$ABDD9E9423AABB2E,$C3ECC7DE562B5431,$6C2A64265EB4366F
            Data.q $16AB7FB54905B418,$0A68C95C954404CA,$74ED23F728D2E18F,$AB16884E651FB3A5,$ADAD21F7388FD979
            Data.q $814E0C7DB8322FE7,$747AB83C2D4211E9,$6CFE1675A767BBB4,$90988208208317C4,$DAEB0C7188210090
            Data.q $9ECFF56EBC3FDA70,$84E27B652173FD3C,$1B3901871D2854C8,$496050C1084AD710,$83F7685C00085D30
            Data.q $87243A50996334C1,$760F389E94372264,$82D0E42820DA9643,$7CDFBECACA6FC804,$3E1F3BAE2A00252C
            Data.q $6BF151D115486EB9,$951F1183D47C48C6,$71ECBC407DF88FDC,$60FC47EEE503F748,$270F9DA793B23B96
            Data.q $B2CFCEFCE575863D,$8208417A9AFA1B45,$6208406503718820,$37CDECF8DAE8539C,$EC93BA82968DFACC
            Data.q $975DD287440E5679,$3051C63850C2DBC1,$86C993BA50AD090B,$5096BAE5B374A1D8,$7EAD987D241E5E7A
            Data.q $2031F4A8AF9B3E77,$BD467CBC8FC48CC9,$7F64A4C9CCF7EC8F,$2CD1EB39566DF89E,$59FDED51FB8F51F1
            Data.q $7E77AE0B8E7CC3F7,$224C1F7F279C97A8,$30FDDB0322E23F76,$F72662DC1847437F,$C4F70E94C7EE24E1
            Data.q $107AE236FFF77E94,$0420121313104104,$371BE9BE5F680131,$5DD5CB9EE7FE9CAE,$7A50A9E050A39765
            Data.q $E5EBC388FC28E5C1,$477D74A6D4F496F1,$9B555DAEDD285ABB,$76FB77A908AE79D3,$89E7F7BC92092A25
            Data.q $820EDBDF791F7A87,$FCFEC3A2392CFEE7,$B0FDC5A9B35F9E5A,$009F1623C71A0C97,$2CF0FDC646C5A11C
            Data.q $908FD9D5DCA92447,$8E5D70FDD953DDC1,$A1BCDD84FE3B0B45,$8C410410428BF4D8,$F66104C41080481B
            Data.q $F7E765765B1F6D73,$B1E050A1972C56E2,$BEF0E42F0E1D7100,$F354CB0C6A86E0CB,$66C66BA5EABD1526
            Data.q $107C5CD978BCFAA4,$07C926CB19BB0F55,$0AB52E1B1FDB6F24,$CA80B7FA863C9192,$46973CB5B5FD876E
            Data.q $3BF52C7CC3F768D2,$3C1809DFF11FB8CF,$413B5880EC6BC4AE,$505E1C83DE7AE83C,$9A7331C231287EEE
            Data.q $E434AF9E95FDA077,$CA16131041041082,$41B3DD8104C41080,$60FE9E87FFD6E7C8,$E92DE925C553C9EB
            Data.q $1DC010FE424FB209,$6334CC192CCB15BA,$9DBA5086B774A1D9,$96AB15A6E9C3B107,$BE679EC1D2A1883C
            Data.q $761F1876ABF7D2BC,$1B73F354DD087D38,$0E23F75EA6C3C703,$585E0A987EE3239E,$ABAC846201DAC362
            Data.q $E87407B833EB87BF,$B2211B18461FBB5C,$0C3F65B04F8EF2F0,$7188208208517E9B,$45B0409882100905
            Data.q $77D5DED7FB8AFA1B,$42253538652ADC2E,$901A7C8063AC66EC,$30418C109084006F,$92A6E3C052E942AE
            Data.q $5E16E205DD287AB7,$BF260A30A2412A57,$9F90F2191892B79A,$70E6FF3128ACF1F3,$5A33BFC91867EA19
            Data.q $CEAC788FDD3463E2,$EDBCCF2C64F3910E,$28F12311A5A96488,$8311B872F770631F,$9C1FFDA94A72A2D3
            Data.q $36CB0ADB2DD9E2E1,$82082083D711BB7E,$304C411608D0D898,$661BE6E874DAAF5A,$82C979E1702BCFBC
            Data.q $F7871E5923D0F542,$C15DD285E7040A8C,$6488EFCF3310D953,$AF4A150C83C9B5BB,$EC6B089CB0D57E34
            Data.q $96AB2C6555BFEAA3,$766B776AF20B19AF,$4B3C51A87EEE503F,$4BCC382D2B71986C,$79EE0C65D79EAA17
            Data.q $C6AE73B6F5773E1D,$5B73F990889E1CAE,$08208208BF98D63F,$202620840243A262,$9BAF8DE0FF374BAD
            Data.q $58ADC6EE943B31F5,$B4EF0E13F0BD3849,$8C781C0B479880CA,$7D62615A4774A1C5,$ABD29BDBA50EDBA7
            Data.q $A195E320F2F3D285,$B866D18F7CF521F2,$A1FB9603F76EB3D7,$415BFAD21FBB17DF,$8F7CF855C0F74012
            Data.q $BCF9F3772C3915CE,$F1FA6C96F11F5A4B,$4931041041052F08,$D769941310420120,$46FD4C966BF3FE6D
            Data.q $6B890DC4F44133C1,$62D99285E942A17A,$CDB3D284CAC6699D,$7E5E94266A43A958,$1B9E1CF521172DC0
            Data.q $1538469F7DAA0A21,$E1FB94696476ED63,$5963C47EE0D7F798,$BB2B47B8320EA046,$7DEB517A5C079E1F
            Data.q $78C41041042ABBCD,$0061413104203287,$2FB6973D1BF39B64,$A9E4A5EBB9C4F179,$FC84BCFD35BC7A50
            Data.q $983AE4873561409E,$90B0B34BEE94215E,$71E74A6FAA3A70AB,$7083CB547CC93D92,$8FEC3CB1BF12FF59
            Data.q $FD99C1FB8918D0B5,$7ECA964B83F77576,$9CB0F8B421FBB6B8,$FEB7770E0BB6F332,$7782AABAE1FB8CFC
            Data.q $B71BA585CD8EBCFE,$93104104106AFC8D,$6EC3026208407205,$A7AB9D259AF0687C,$7A582352F29C2D4F
            Data.q $57851C79E0C7884F,$8D692C31EB8F0A38,$E46B7082F6AE30D0,$1CB0478F192E1CCA,$D07732C91C41FB24
            Data.q $791E7BCEE620F3CB,$33494ED1A6B1F2A1,$FDC70F6F30FDCA18,$ECE6F0D543F719E0,$F729E05F7067E8FE
            Data.q $D662201DABAF33C3,$410422B9CD13EF2C,$4C4108048144C410,$6EBD37E3C6D75870,$D25B27EE1696DAC6
            Data.q $3EC2861EEEE943CB,$31E21324C82C7875,$426211682F4A165E,$721E3E942C8D9CE9,$C3349A359231A321
            Data.q $9B87ECEC5FFB30FD,$32411889E0787EC9,$C1D1287EE54AE79E,$D65C163F676BE162,$FC8CF69BC5968DFE
            Data.q $120993104104106A,$7C6D96F009310420,$72E7B0FECC37CDE2,$7DDD285E61417AB8,$CDD87EC93270A18C
            Data.q $6FF199A6C3AC1E58,$3268FD8EEF3D2860,$11FB946970C64411,$5497A787EE0AC88B,$FB830F6E1C1FBB96
            Data.q $F0AC11EB9D0DCF12,$1041041FB92E99E2,$D092620840241944,$FA62BF5F2FA6F571,$A1323E7296334C17
            Data.q $40614701F851CE74,$3C422D74A1651FB9,$22374A10A878ED69,$4EF65586F4A111A4,$082D23F708D1C112
            Data.q $63070B243C3F77EB,$C0997777416D6A51,$EBA422DA0F178B39,$1B47CDAEB0AFCE8A,$03C9882082084D75
            Data.q $A5325C4498821009,$8CD4FC745745DEED,$782900B4413BC560,$1B831EFBC1896E1C,$B8B2A9D4DC211DEA
            Data.q $EE1BBE8E1CB8CB19,$FF95AB5571E13BEA,$F2989BCA3F759070,$164F743DC320BAC8,$D7D91FBAB52B51D1
            Data.q $578F67563523F76D,$30E56E3C78217119,$1867B908CE8C4F6B,$5E16968FDD9593DC,$06AFF47A7D8D399C
            Data.q $4201211131041041,$6CBF8362B6089310,$21796ACD17F5D4C1,$BDD28561F11BA30E,$4828F09447851C33
            Data.q $D2874422D30884AE,$E9436488ED7EF33D,$7237A508EA442DAE,$1FBA918E8A326B14,$334983F77283BFE5
            Data.q $11AE25113CB80576,$58B0570E0E7826A0,$D70FDD959D8FC6A0,$E2D917C77E72B861,$410410BAF2378E07
            Data.q $C931042012079310,$C67CB75F4E1B5D60,$E883B5D06736F6EA,$76C28E39E17A5099,$438F481C582FD33D
            Data.q $5B9D287658CD39E9,$F4A1646B19A4F4A1,$7EE2D4685C86F77A,$BDFE23F7257E7DE4,$BD07886E2583F71A
            Data.q $C53DC38CB87AC3F7,$430EB87EEF96BEE0,$99F38A7338338B6B,$84C410410410BD51,$965A424C41080486
            Data.q $7AFD67EBE6EBBFDD,$4B563B4D141D414B,$24F7871E7BA50921,$E942B0E9CB05E143,$78C7878E310D958E
            Data.q $94270D6334DD286E,$BB668AC7796B1E3E,$65ECB676C79E711F,$8C3F75CF07EEB983,$C5B35FC745745920
            Data.q $410410B2F0354E9B,$49310420120C9310,$CD74BFDBE9B15F69,$BAEE942A782D3FCC,$C1430EBBA73661EA
            Data.q $1CADEBC398FC28E5,$B240699658CC774A,$7A50DC3AC0E6E942,$0F185AC2E2CCB1FC,$B88FDD2C64CDBED5
            Data.q $70BF9DDB8304EAF9,$34CF4EADED0CE1D0,$2082085EA8C5FE16,$2620840243C26208,$2D5713F07C6EB331
            Data.q $0DD648376A60F29A,$1525B830EFBC3889,$A21BB10B0ACB374A,$E94260BD2856EA43,$B768FA50CC304726
            Data.q $8AA9CE7DEA244D62,$5BCB3BF30FDC3ADD,$29772FD0FDD95936,$8B5863DB3BD76AE1,$3DBBF2B60BF94C17
            Data.q $A4C410410438BF0D,$D18820801FEB1DC2,$A7A07E7797900183,$52E5C5ABF2F2DFCF,$7EF5FA108003F102
            Data.q $F4C9013B8030F909,$718030084A420243,$32E0290021BE6948,$19BFF11003825EAE,$7CC3877DA43D7D42
            Data.q $40493EA6706ECAB1,$9388C88094BF4382,$A064CE7CB51E72A1,$01CB8B809ABF7052,$5C1C0427187EE5A4
            Data.q $905C6574D339B1AA,$E74CB812974D11B8,$429C18FB70645E3B,$4F70ECE86715F34E,$105AFB47E7D17A75
            Data.q $0840721F13104104,$BE5BE86D16C39262,$DE27B74ED4F563BC,$C2AC66ACB21A6207,$92258A3D49EF0E71
            Data.q $E942F27547A787CC,$8CEDBA50BCF41DF6,$44EF35546F4A12D4,$07EE8A8007EEB863,$5549F7930FDDBA80
            Data.q $930FDDA0F7FD4AF0,$E6BA1870FDED48FB,$61A0707B2D967E77,$90B4988208208517,$0FC5D6800B882100
            Data.q $15E7DE33B5C3791E,$56592325838250B8,$47AC3DC19DB79633,$58CD316F4A1264B1,$2D6101D935C43656
            Data.q $D56335ABD284CBB0,$FD5822110B1F4A1A,$855523F71EA2D18F,$20723C5AE0FD939C,$C3F762EAC661FB37
            Data.q $CE330770679F4EFC,$B44F74ED4C7EE587,$081577A30FFDD6BD,$82100904C9882082,$6FC3F36ABD6840B8
            Data.q $4261FB8D47C676BA,$41FB53C17F3CF6E9,$0B3B00A3E729AF0A,$E7A50D93BA50E2C2,$EF6FFFFA50996334
            Data.q $7FFF3BCEAAE4E3CE,$2ED6A6F56F7BA9CF,$0458920B40210804,$49C7B1B1C7B18C08,$1E3316718861031C
            Data.q $78E5F9FE32789C67,$271C63F266FF193C,$DB1271ECE38F1C43,$31616841D82F1E21,$76084C6305B08660
            Data.q $0898B162C42D58B0,$FBFBAAD35210642C,$77557556EB7BDCE3,$D7EF3E5A9D557755,$7AF7D3EBD5BABCEB
            Data.q $64F54E79E73D4FB9,$64CCD6A9093E54AC,$9AE64ECD282476AC,$E7DC3F5656AF24CB,$EAAA87DD91FAB49D
            Data.q $AF9047EAFD5CFB87,$AB0208FD5FACEC7E,$6DCB7984FBCE57E3,$84830000157F6707,$F9AE9BE320180404
            Data.q $6CE2A97F8FD793A3,$9C34907A6A773090,$AA3049357A28C37F,$ADB187A535556327,$826E53F6DF958C98
            Data.q $F483E7AE7D29BE9E,$036C3F5456AD56EB,$B23F55CC792C8FD5,$ABB583828CC7F4A6,$F760FCE16AC1411F
            Data.q $01CB81DE5E4FABC8,$3980C0202413E800,$7C315AAC0F81D0E6,$C74AC16E91D2454F,$0E8A37AE0AB41EF4
            Data.q $E4E4E6E5B5870927,$0D987D3D293D3521,$EAF4A4EE9A58C9D2,$C56ECDE949FEA464,$17A35568D212756A
            Data.q $C7F2993EFE411FAB,$047EAFD70E3F54A6,$B1E8EAB460A15581,$ABFB393CFFCD9B8F,$80C0202434180000
            Data.q $E613C6E0EDB96F31,$12B94CF47E70B45D,$1FE8AB79FD29A352,$D261E94DF37963CB,$3A7A536EB6C61E94
            Data.q $BE5578A915ED378E,$68769092BEE94D4D,$28FD529AC4C3F567,$AF055A8F047EA8D4,$532B9DC0823E5655
            Data.q $5D0E0F44164B46B0,$40000E5C0E8AEDB9,$B35990060101211F,$58A8BC2DA759CF6D,$94DA9909564113B4
            Data.q $47C974ED14683C1E,$4A0AC36C9448367A,$241B392A1ADB1B36,$1B2697781E9E94D7,$2BD2125D3E94DABD
            Data.q $847EACD4C9428FD5,$3F5693D3D647EAB9,$0FD5A9990F0A8D26,$52F47A3D8E464E5B,$340000CC19B93BF3
            Data.q $6D9AD15018040480,$86B80F92F361BF77,$DE1E94DDAA28A374,$F728FDEE5D3D1469,$B513E550F4A6B882
            Data.q $D6A9092B5E94D367,$AE2D7DFE73E94D6B,$D8C23F54A66B587E,$549441569E849E54,$47EAAA9092491EB1
            Data.q $B45F74496CB1FFDA,$40000E5C0EB6EB7E,$C6D8D8060101219F,$167F05E4E33C5FED,$29B2A3E55C6ADB26
            Data.q $97A2AD37D156303D,$2493D29BAA423393,$E42F4A6F921BDF24,$2E8CD5A909348C92,$7FCF9F1AADEA9E55
            Data.q $EAF5E925513A74DD,$C146C6C3F54EA147,$EE7A9DC988F051A4,$FA1C8E2B1FABE6DE,$1BB40007FD6CFEED
            Data.q $F862788EE0300809,$82DD25BB1B8E6B23,$5F0F4A6B92099D95,$7551A60F73AF0AB3,$E646B94B25BA7A53
            Data.q $07D24755CDBA535C,$C64F331FABAA82E7,$823F564E907E941A,$08FD5761E3F54EB8,$4BE5ABF4F558EA92
            Data.q $076371DBAD0F778A,$0080910FA000072E,$D03029A5BC5CCE03,$414449002000006A,$B91D77E1A8F6B454
            Data.q $2B261E8CD657786C,$559F68A3020F4A69,$560264A23C4BB374,$F4A692B193CA14D1,$7CEDB4EB55AADD28
            Data.q $1FABBEE94DA03222,$1FBD553051FAAE61,$36047EA92D7828C6,$E424D3CE9B48F9EB,$0095FB9D2E86A398
            Data.q $EB320010122A0C00,$C70BD1DAF278BFB7,$889F28C083978346,$1E890FE931558184,$4C9562B64DEE8AB7
            Data.q $5BA61564A0AC64C5,$F9E94DF2B19372AF,$4A6DED58C9E5BC71,$5CC86AAED212476F,$428FD58CEC811FAB
            Data.q $A4E363DFDA47EA8D,$FD5A98F9ED3871FA,$EDDAE19DE288EA38,$010600000AE7B737,$D5FD715249000809
            Data.q $B25C4BE2DA70DF3B,$D29B9518B0A03E51,$71E0A327FC2AD0C3,$9283D29AE474AE53,$4D5A9413490DE8AD
            Data.q $77A53776AC64E9E9,$FE1FC9AC3F547693,$5F772C6C3F5559A8,$9464BD1C7EAE6626,$0040484E600007EA
            Data.q $D36B38EDB61B8A64,$3D774A6BA1478FA2,$82447AE0A4156900,$CB7963CB8FD62B64,$7B2AFA56326E20BD
            Data.q $327ABD29AAA7BDB6,$5410AA67D29A6CD6,$FA47EADB376E9CFF,$8CF9D3691FAAE9EF,$F55EAB655C878FD5
            Data.q $AFEB85B7C311C563,$E7D0000297CDADBA,$35DA745854004048,$B38AB6F8ED61BBBF,$94D725856326AA41
            Data.q $217D248467244D1E,$4A6B9EA4D2486AE5,$57CEE54F4F4D4F4F,$93DBAD5E94D3663A,$AB999B1B0FD59F10
            Data.q $7EAFD41F828C871F,$7EA986CB91D18104,$80001DF02CE60000,$FC9793E3C52462EE,$F57D9FA7DAD0F978
            Data.q $4A54A925B29638A4,$D149437C56257FDE,$5E3EE36295B15679,$C71563246495638A,$EB18149714940FE9
            Data.q $E526EBF3B94ACADE,$9BF49155FE715FBE,$A4A8CAC0495C92A5,$FAE7B94A9636FCB8,$5A5F79F4CCF5E3F4
            Data.q $9C276484F5C8FD56,$0AB4B8B6C91FABE7,$930782AD8E4D8D95,$8C1411FAB53847EA,$55DD70E6E8623E8E
            Data.q $1EFA000062FDB677,$3A6F539853001015,$878FE60BFCED61B0,$4C9E98DA47AAB37B,$F0AB19E8AB430AC6
            Data.q $D558C9D3D29BB5DB,$69E6E558C9F9E94D,$42F6F5C7E7A53593,$6BD23F547C237A53,$1FAAE428FD53A859
            Data.q $48FD5DAAEC1490F6,$00FD52288F239193,$869A80080904B400,$DF0BA9E67DDD6ED6,$DE530E12E4B6461D
            Data.q $7FC2AD0AC84E9592,$D8A377E3711E8A31,$E94D5520D9D92325,$1F493934AC64D551,$26EAC64C8EAC4DAE
            Data.q $7AB533BDA47EADB3,$AE4DFF696FADB23F,$8B936D971ADD23F7,$DEDD4F1F5C0782AD,$BF6CD70C6E47238F
            Data.q $48FFD00003D713BB,$5BF6E27C35D40040,$47EAD247D16339CE,$5685158C9D3D29BE,$8FDEE5F3D1466DC1
            Data.q $5BF3D293B2621272,$CECAC64E6A6B0280,$64D56A958C9AA8B0,$947EAAED28264EAC,$B2B8851FABE9B393
            Data.q $41C7EF59262691FA,$1623A40823F56D33,$800000F5D56F1F07,$F57C9FE6B4C00404,$73E5E5FE7EB29D9F
            Data.q $CEB82ACBA5346A41,$B57B957A99357A28,$584E1E93EEDB943D,$BAAB193F30B03B90,$A5363F56327ABD29
            Data.q $A92D43F57CD0C757,$7EAAA9EF9207D87E,$F472398E464B8104,$39703A7B8EDD68BA,$8CC0040482030000
            Data.q $8C56E38DF91FCC56,$D2B05BA474915DDE,$45186FC2AC27D393,$9B90FA6DD0D39387,$1A6CD902AC6E949C
            Data.q $D293ED50520FDA56,$491A8F12CAC64DEB,$51FAB7B483F5B748,$5363C7EAA736B6DE,$974B488496411FAB
            Data.q $02452D00003F5444,$0D8996E366466002,$27B46178B85F8CC7,$AFF87A53757A427F,$D6D8AC36C9EDD156
            Data.q $6AD48497630F4A6C,$E2BD11AC8E934F4A,$127F7522126A7B61,$BB23F54D9DEFC8D2,$F576BF7C7EA9733E
            Data.q $8EE8F47958FDED23,$0039703AFBB6CD68,$CC43400404840300,$85E1793E6DCF2DC6,$CA42549060F643C3
            Data.q $AC47A3D29B948567,$61F2E241F393FBA2,$AD7C4AFA7A536985,$57D3D29B2A6B74A6,$64248EDE94DDDBF4
            Data.q $ED208FD59DB33F2E,$7EACAEEC146039B9,$C5A53051FAAE4184,$472D00003F548BF3,$F76DBAD161A00202
            Data.q $E90D735FE2F37EBE,$8C083D29BAA417AE,$F4A6E53DA28CBBC2,$0F67A535CD8501F2,$6A9092B5E94D55D9
            Data.q $4F09335AB7A534CD,$ADB5FF276575671A,$240F05598FB87EAC,$315D8E3F54EAC893,$F2B7F7ADC4F1557A
            Data.q $68008091200000BA,$D4EB395F1D86D8D2,$3FFA4F2D5EE47F85,$E8AB181E94D15B22,$AA4233924FD1569B
            Data.q $A90DED2424D3D29A,$53408C92E42F4A6E,$5356A424D2F3D29B,$374E7FAA9B5B4CFA,$78FD57AC23F56568
            Data.q $9D91FAB5363EC8C5,$4FA28B45A5305E7A,$02463E80000CBC78,$D6FD0F764B69A002,$620B9F2A6EC7E3BA
            Data.q $69387A5372905E92,$56ADBA4C146B5E15,$117B49112CDE68E9,$DBA8359363EE57D2,$94D7AEE87D24755C
            Data.q $7EAA9D58C996EA9E,$EA147EA9A6B01364,$3F54975F26763F55,$18AD563F5456C0C2,$7CE707D6CD717AF9
            Data.q $40040481A8000031,$9D8FAB4A5BC5CCD3,$38AAEF0D9723AEF7,$35B26D162AB43D25,$2AE4DD156FDA28CB
            Data.q $C85345E7CD71A11C,$5B74F4A6B9056326,$B756327E7A537556,$FAA6698135CFA537,$572F1E3F57D9A561
            Data.q $FD570F12CD82823F,$000FD52DF305A5B0,$731598008090DB40,$DE779FAF27FD96C2,$5D3D157D3FB058D8
            Data.q $9E89115262A0A8C5,$32558AD929FE8AB4,$6E98559282B19315,$D9E94D73A61B4ABD,$73FD5E94D07DFCAB
            Data.q $047EACA81E3F55BD,$CAFD1CAFC71FBD55,$000B96DA3CD789D0,$7141CC0040488000,$AFC96D39CF87F6ED
            Data.q $561407720A5B2314,$444DE775EF0AC64F,$0DE8AD9283D29A35,$23D1D2494B981EC9,$7F3FA47EACEDE94D
            Data.q $F26AB646038FD5CE,$0BE3933023F54555,$98000043FA737BF5,$BF5A193980080901,$14697C5A6DD7BAF5
            Data.q $632653B020F4A6BA,$62F8558B7455A145,$C64DC417B96F2C79,$2B193CB637B55ECA,$94D8DD21269E94D7
            Data.q $DE51FAADCED7C8DE,$8E57E38FDECED682,$FE1ABB35F568657E,$00101205980001C3,$A4FF7FABB4F0B673
            Data.q $572905CF9657E3B5,$3D29AE4B0B43B243,$61587722119C943A,$AB883D29BF521AB9,$66237A5350F521B6
            Data.q $4F047EAA2D047EAA,$1D65CC0B1FABE9D8,$1DF02D03000183F9,$85C3C52467DE8000,$3E1FDAF0F978FDF7
            Data.q $5492D94B1C53607B,$A1BE2B1ABFEF252A,$71B14AD8AB7CE8A4,$B192324AB1C52F1F,$0A4B8A4A07F4E38A
            Data.q $DFB29525656F758C,$A4AFF38AFDF72939,$560CCAE4952CDFA4,$CA54B1B7E5C52546,$3F55B1EBC7E915E5
            Data.q $47EADB33A7E7DEAF,$7F67A462AB8DBFC5,$FF2A51FAACA195A4,$EAB90FD56522AD3B,$F5415C7EABA69587
            Data.q $B400405409D00003,$2FD75381ED7CD984,$7AAB37B878FE60B8,$0C2B193722B1D3A4,$ACD96FA2AD67A2AD
            Data.q $B353630F4A6F9202,$483E7A56327ABD29,$5A7AF4A6CED00ABE,$5B8987EA9A77B632,$F7A223F7B998FD57
            Data.q $5A00202411D00003,$B29FD7A9E5B09CC6,$A384B84ED162A2F0,$A1E8A37DF07A5376,$9B24233E5C562B64
            Data.q $6326AA8F4A6B958C,$987B983FCDBC9359,$C7EAB2D1F268D58C,$E3F7A1981E3F7A5C,$F54AD84E862BB198
            Data.q $5A00202411D00003,$5F4E738EFDBF5C2A,$3D29AF51FAB4E1FC,$51FBDCB67A28DDB8,$77217A52764C424E
            Data.q $7A535EA8CDBA6120,$AD52126A692C64F5,$CD5CC209D558C9D9,$7EA91BBFC9B0FD54,$FDE8158C7EA97304
            Data.q $968008090C740000,$E36D3EBF8EF2779B,$E94D5A8F5565CFFC,$324AF455A6FA2AC6,$F54958C9E5362AF5
            Data.q $0CC3B8CB2DB25423,$27ABD29BAAB193F3,$D29A2B5B8FFF5563,$68F55A47EAD7359B,$F530FD574C11FAA4
            Data.q $D0FAFD18ADC71FAB,$18E80001FB9CEDFA,$91BCE4716D001012,$18D99DE8EC7F1D0F,$7A6A7CB0904CF4DE
            Data.q $38745186FC28D070,$462AB09326DD0D39,$58C9D20AC64E56F2,$D958C9BD7A527A9A,$20FD55A4248D7D43
            Data.q $EACAD5E3F548EACD,$7A1B8FE7CF53AD47,$A00202451D00003F,$8D57EB132DC6CC2D,$EA0C27B45164B85F
            Data.q $26B745582F87A537,$96C9311124E2B0DB,$7C9E3F4C3D29A4AC,$AF912FDA7A535EAC,$9092675221275426
            Data.q $5B671983D23F5476,$E18AD57CF53EA8FD,$48D3A00039EA73AF,$EF65B3598DB40040,$70B86460BC2CA719
            Data.q $A3D29AAA4257C820,$9562B64BDF45581F,$64A0AC64E92119DC,$569E94D7AAC64E6B,$1B199D3E94DDDA09
            Data.q $BAF19208FD5967DA,$9828FDE94C7EA9B3,$23FEB313F6F982D2,$6D00101225980001,$2C6739DF76D9AD15
            Data.q $30841EBAC8C58FFE,$518107A5349207D7,$23A55CA9E8A36DF8,$D4CC86F5C85E94D7,$D7A53757B83E9E94
            Data.q $AB9212A5B5AA424A,$6C8FD534FCFCD47E,$AB55B260F1FAA6CD,$3F542315AAC7EF4E,$BB680080905E0000
            Data.q $0BC9C67EBFDB0D91,$8A9B8282AC0C20FF,$AC0A3D29A2B64515,$ABF6DC97C2AC9BA2,$4A6DD4D885E94D5A
            Data.q $5375563B7490934F,$9F4A6AD4849A5E7A,$6F7FE7D7DD32126B,$9047EA94D243F575,$B2341C7EAE9A7A54
            Data.q $48A0B858FD5F4D8F,$0010120BC00007EF,$3FAF6FD0F774B11D,$28A32C16F2FAEC61,$C3C2AC14120259B2
            Data.q $F9DCD7828C37E156,$E92139FCDE68E91F,$A534947A5369FDAB,$E94DF4DF707F38DB,$069D1253212756A9
            Data.q $AE6A7934962E1FAB,$91FBD1AF3A4EE1FA,$5E8C7EF4A6147EAB,$28FE86E1F5B75C59,$474004048C5A0000
            Data.q $EF395F8E94B78B98,$0B62B87A1B2F9697,$243FACDA2C556856,$A3349C51212AEFDA,$78FD23F5554749A7
            Data.q $D366B193F3D293AD,$E4AA9095D34B5E94,$F3708C7947EABA63,$FAB754C04B308FD5,$A030B1FAB2B60611
            Data.q $8008090DE00003F7,$9AD27FD96C27318E,$FB2BFB068E8C1779,$85594F4563272A40,$F0AFCA9562B649DF
            Data.q $559E94D74FF2AFA7,$2D5CFF9E94DC5A10,$9AC3F56CD5AAD9B3,$15646D7A428FD5A9,$638FD50CE77656C4
            Data.q $03F54EDDAE2CAE46,$1A8E8008090DE000,$F858CE73D1FDBF5A,$6C98709725B230EE,$519F7856327E564B
            Data.q $D9283D29B35303F0,$8492520B6C90DE8A,$D6A424A67D29B5CC,$87EAAED35F15EB69,$5047EAAA823F56A6
            Data.q $E83F5754282AF935,$A0020245F80000FD,$A7F5F1B8EDD686E3,$959208FD5A58FC2E,$562DD15685158C9F
            Data.q $0551574909575EE1,$0B03E5E94D64C685,$93ABD29B4AC64FEB,$24AD5E7A53755490,$0FDCEE99337DFF24
            Data.q $847EA866C45B9549,$AAF462BB1C7EAC73,$003418CE0FAD9AE2,$058BC00202446D00,$BF1DAF2787F35DA7
            Data.q $B6486AE5047AAB22,$24983A3D29AE4B3D,$ABD29AAAB193D518,$6957260B2B956327,$3E94DA3548815A98
            Data.q $B23F548DE78D5A9D,$FD5036C3F546A924,$3E1E91FAB35507B0,$EA80E2D1694C1418,$DE0010123BC00007
            Data.q $0D4795B5F85C331C,$92B05BA474915BDF,$28C1B82AD57A24C4,$9E94DFAD8709252A,$BF5E8CDA4C0AC64E
            Data.q $DCD258ADD4D03D29,$FD5B3567A6469092,$D47AAB91C25CB130,$1FAA99DA0F047EAA,$8DD59CEFB7AB8ADB
            Data.q $7800404885A00002,$F335E4E07B5F3663,$84AE5F3D1E305C2E,$33BA2ACE7F4A68D4,$B0F4A68ADB1586D9
            Data.q $E934AC64F57A534E,$C6CB193F37A53728,$7EAD9BC7FC9113F5,$A7F1A47EAAD7EFA4,$1C7EA8AF6FF48FD5
            Data.q $B458FDEFA6C78292,$0481DD0001CF5384,$673DB6CD66578004,$044ED162C2F0BA9F,$D3B07A536A642559
            Data.q $4F72E28FE55E4A28,$6AA8F4A694EC6848,$46D30A43E5359632,$9113E54AC64CD9EF,$AAB5BE91A664A4EA
            Data.q $EA8D428FD50CC11F,$87828D8DBC3A7A47,$490411FABAA8455D,$AE13C51D91E8E3F5,$20240AE80001FAA6
            Data.q $1BD776DC4F0BBC00,$0EEE90D741F458CF,$1461DE1E94D5AC28,$0AC64FC8FDEE5B3D,$4D576DB24173B265
            Data.q $6F3348849337A536,$5756DFE47EAEAAB9,$EB87EAD31483D23F,$8FD5A9AB56C9B10B,$AC2D370982AA4920
            Data.q $A90C2F169023F56E,$80080906BA00007E,$E3385FD5D27A30AE,$2AEE8A9E917F05A4,$6E8AB181E94D951F
            Data.q $6EA908CE4E5E8AB4,$BD486F7C90924F4A,$9253E94D9540F4A6,$EA8D954CC8493A87,$748FD534D8F8ADEF
            Data.q $7070392AF93658FB,$7A94ACEE23C7EAC6,$5A2EBD1C8E638FD5,$000023DC56FEFDB7,$A238D7400404815A
            Data.q $2DBD1AAF5647ECF0,$4A6B92099D9582DD,$93051BD785190E0F,$4B74F4A6F92119C9,$34F4A6BD56326E56
            Data.q $9DAA428576A82801,$EF522FD1AF1F6484,$A8E4B9B0FDEA66EB,$D8D87EA9D411FABA,$428FD5FAD1E0835D
            Data.q $0007EA88A2E968C1,$661AE8008090ABA0,$5DFC763BAE4F3FF3,$C3D19AC89F17174B,$2119C90BE1E94DA9
            Data.q $9367A434947A5349,$9115A56326C9ACB1,$B7AAB1935AF4A6EA,$6BBFE921256AA54B,$B69988897A9BAE36
            Data.q $3F33B930E95151FA,$0E3F5493023F546A,$4DF0F962B57C9FD7,$018EEFB6F76DBAD1,$C55D0010123CD000
            Data.q $2F0B0DB4F7B2D9AC,$E88DF2081C2E1918,$77D15663D1E94D55,$59E90D64C9408A93,$74A6F958C98D7A53
            Data.q $DDAAC64F2F4A6B9B,$EBC6F5212655220F,$C9FBE9B5FCAEBFE6,$35349647EACB37DF,$0FDCE224BE58FD51
            Data.q $75D0010121D74000,$97D39CFFBD6E278A,$7430F4A6B918B7BC,$AB42D0FE518AB1DB,$23A55C89E8A36EF0
            Data.q $C2DD2B193D5E94D7,$5D358C9D3D29AB54,$26D330B92B54BA53,$A47EA866EBFAB629,$35F2611FAAB5E84D
            Data.q $ED5AF0559763F559,$F0D97A3A305047EA,$BEF27677EDBAE16D,$5D00101208D00001,$753ACEABB6E36469
            Data.q $041E94D7428AFFD1,$60514663EE58C9E5,$4D1AA5F0AB5FFD15,$EB3B89B4AC64C9E9,$2B193D37A535C89F
            Data.q $B4DBF4DE574909E9,$D2C45B151FAA999C,$4A3F57C965ED24C4,$F556A364E5C3C146,$00003F54C365C8E3
            Data.q $745AD7400404895D,$4D7E3D5FAE9735FA,$5818486AB920D9C5,$90E0A35AF0AB2585,$43572C2B0F4F4A6B
            Data.q $6A7A7A535CF52692,$ED788372AC64F57A,$8C9D5182655258ED,$AE6F666EAACB4E54,$4F94F2691D2591FA
            Data.q $7EF7EA2615597698,$55DD70AEE874B91C,$B8D000014EEE74B7,$14918F50000077C0,$B7E2A5EFB25F151F
            Data.q $652C710DC1D1FE9F,$AC72FFBC94A9524B,$AC936294EF4926F8,$B192324AB1C52A58,$0A4B8A4A07F4E38A
            Data.q $DFB29525656F758C,$EFD54DFA41115939,$4AAF3868D7149597,$2A323257C98D4C5E,$D5CB8828C607AC37
            Data.q $549C411FAB53508F,$31EAB48F95761E79,$755ACBE188E3F7A5,$00202A356800000F,$1B0DFEC373599ABA
            Data.q $13A5F60B1F182F46,$D158C9B95909B2B1,$A9562B64EEF0AB1E,$9B353103CEE1F3DC,$D4C50AD29EDBF3D2
            Data.q $15299AE9C6B558C9,$3A347099535FDA91,$C2AB6EC7EADA6AF9,$C471FAAE47AAAAC1,$BEBD6DD686FBA1D2
            Data.q $809146800009F7D3,$F5D9AFAB437AE800,$C96C8C2BBD1753BA,$19372B25BCA61C25,$A999150C9BAEFC2B
            Data.q $C9AAA3D29BAAB0DB,$B558C994C58F5958,$1F73D09A533963B6,$933EB26C4B9F3ECF,$ABAA3F7AAB1143EA
            Data.q $B950F0A3F55C851F,$8AC849A482AF91FA,$091BBA00007EF4E5,$CDFB61B4309E8008,$23F569A3E8BE9CE7
            Data.q $6E890DEB96EE94DF,$B7244749779E8AB5,$AC8755CAA1E94DF2,$88497AAC64CEBD29,$8967555CA9112CA4
            Data.q $5936FFC6CABD6D54,$0A309E16EFC748FD,$B8B0BA58FD5FAD5E,$043B9F8775B75A33,$8CF4004048634000
            Data.q $9FAEA727FD5CA7F9,$A9DCC241B38AA5FF,$F451BD7E70D241E9,$A92B193F2AF5326A,$2C0EE4161387A42C
            Data.q $8E91C59E958C9EAC,$DD4D6E99095DADE7,$55F2619DFA8D957A,$28C828FD5723E545,$F5454C3F5556C878
            Data.q $52ED4D974391E563,$E8008090BBA00001,$15AADAFD2D2F4729,$AC16E91D2454F7C3,$1BD7855A0E893124
            Data.q $26249B101E938745,$A6CD902AC6E949E9,$749092B520FDA561,$3C4DA609093E54DB,$9AF69DFF955EA7AA
            Data.q $FD57338B2AF9374C,$E5E0A329E0A35828,$A347C20B458FD5FA,$0000E6F5E95FB72B,$ACC53D00101200D0
            Data.q $5C2E0B71E36261B9,$DA99095CA67A3F38,$7963FD156F3E1E94,$497630F4A6AD6F2C,$8A92424B2C7C9048
            Data.q $39DC424B91A3D644,$DCAC16C6A364F921,$525BDA573B6CABD6,$047EAA67E01A5332,$6E47EA8D60F051B1
            Data.q $7277E665C8D47B1D,$202452E80000BCE3,$B399E5B7598E7A00,$4113B458B0BA2D36,$683C1E94DA990956
            Data.q $7AE71447C974ED14,$0EAB4982F4A69242,$1269227DA56327B5,$394C7A67F22D5692,$249255CA3E493CE9
            Data.q $563B796C49FB48F9,$AE4789A4C147EAAD,$E576BFB051B4F1FA,$0F760FCE168D60A3,$002FBEF857C7E8FD
            Data.q $8A4F400404823400,$7F179B0DE7BD6ED6,$A6ED51451BA435C0,$81F2E9E8A34EF0F4,$30F4A6E558C9E584
            Data.q $2127556327E46C97,$9A795355428EDEF9,$FD2B45B953621478,$2272A5047EAB1ABC,$58FD5F4E763F5592
            Data.q $4DB72DE693F462B5,$2406E80000CD74CE,$5F1DC6D8D67A0020,$5606127F85E4F33C,$07A536547CAD2141
            Data.q $39397A2AD1BA2AC6,$8E924C3D29AAA423,$125556326E486F72,$115A4609A484F692,$BC6CF546EA8F1349
            Data.q $D9138A9ACB613A6F,$E4BC14673C7EAA1B,$C163E31FAAB5272A,$02F7DF25F052A19E,$69E8008091468000
            Data.q $A3559AE8FA189F4B,$724133B2B05BA737,$519D7855A4E1E94D,$BA535CA2119C9930,$6326C9092491D572
            Data.q $AE4157ADB9212755,$B130F93E7EFF3D21,$FBE932B18157ADB2,$03C12E2691FAB99A,$047EA94CC17AE349
            Data.q $36693F462B71D581,$6800001F7DF0996E,$DE2E669E80080914,$5C8FBBF8E47B5A52,$95930F466B2BBC36
            Data.q $2ACFB4518107A534,$E7CD71A11725D9BA,$A15F2B1932985345,$34FDE4AC4C424EA8,$498966C484B9B109
            Data.q $528556ADB881F590,$7EAAD79837C94139,$182F0558C504D214,$C1A3798FD5DA82B7,$03DF7DCB83FB2373
            Data.q $00000EF8119A0000,$87A1E2F2DC6CCAE6,$BDBE264FFF70B82E,$58E2AD8E2C7895FF,$8BAFB38A54A9638A
            Data.q $7DD9B4967FE2971F,$A4962AC64A8C64BC,$232564A91AD8A4B8,$7B925495931F7629,$46B248CB14955B1B
            Data.q $D7250983D2B1C52A,$535811F24A692E9C,$EA7F2AFDBA61F871,$1FAACDDE8F2A5079,$E3F7A53B0FD5F33B
            Data.q $1CB71B369FA395B8,$A815A0000675D4EC,$EF57F5C50BE80080,$AE46292F4BE9C37C,$62B6462905ED3D29
            Data.q $B76EC1464FF85632,$193774A4FE542B15,$A53F3F4C250E4C2B,$B4AF554FB7971212,$BBD72C4C3E4D3D39
            Data.q $D8C2417B4F3C6B91,$8CFB1FAA531B2454,$170C8C7EAFD5CF0A,$1DD7DF39F0551C5E,$1BE8008091668000
            Data.q $E2EA7D9C775B0DC5,$1A820F4A6BA1478F,$C2AC1FE8AB02B193,$5C6212728F93971F,$AE21BD70CFEB9212
            Data.q $B2991134F1FF2427,$A6FB46E47CAE5362,$1F7260A6A4D2BADB,$B41E3F5598401DCF,$CAF563F54EBD09AE
            Data.q $F7D9796E366A7F79,$00202459A0000735,$8DDDFEAFD382CAFA,$6AA41B38AB6DE66B,$44D1E94D72585632
            Data.q $3C6AAB193F2AD532,$8992E7187A5A7A6F,$CAA0AB5522272992,$BCF1BE47DF69576D,$1527FD2564B6E710
            Data.q $5FAC3F0A8D978FD5,$F89A63CBEC8A18FD,$A0D980001AD7DF33,$91E292315F400407,$FA7DAD0F971792E0
            Data.q $D8E2417B4A4F57D9,$C4AFFBC94A9475B5,$FD26CF3A29286F8A,$A3F1B94DEE32C91D,$7190EEC44D58C8A4
            Data.q $E8A99254AD874B1B,$2C794D646B59492F,$2BBDB271847C9A6F,$1259EF0DF308F5E9,$5B8E3F5433442494
            Data.q $3AFB35CA7359FA39,$10122D6800014573,$C1C0F6BE6CC77D00,$BF2657E5E0BA2F47,$21245496D7A5EFB3
            Data.q $9F8AB629562B14B1,$9B14837E296DF491,$71B1092E14E45564,$962B0EB15269192C,$5363D89AE495638D
            Data.q $7265789938988499,$9569855EA6E61B87,$ACB6DB726BF91D24,$F57EB27828C07051,$1FC18B0B83D918A3
            Data.q $6C5AD000026AEE77,$DD6ED68697D002C1,$DA2C5DDF0BA9E67D,$DCAB72C36F2C30C9,$FAE23D156FDD1E94
            Data.q $C3E5E7CD66D8A240,$2139C9C610F25D0A,$9ADD30B43922C569,$E4CAA63E4C330EE5,$2ACA11FFDA77FD23
            Data.q $3F9EA7F30E03B9B4,$1D563F55EA4DFAE8,$BE73DB61B345FA33,$020245B300002FAF,$B396FDB89F0D6FA0
            Data.q $68907CEC91FC5F4F,$1BB7855A187A536A,$9B7B9281924A3F05,$ECADA1262492119D,$45FAE46EF495090B
            Data.q $555CA6E302C7C90A,$93D6D3D3BFE91F24,$21C14632C76D93DF,$FD5247CAAA89E0A3,$0F17266041460A08
            Data.q $CC0000AEBEF94FDB,$E4FF36BE80080905,$C3CBFCC369B17F1D,$537C8F9572C64DC0,$01D1560DFA3A727A
            Data.q $0A68A32549445C97,$313B2B1D3A56426E,$511C24947A727CBD,$3E412D249861B872,$6E80D64689CB8929
            Data.q $F268FE80DA48C972,$C57E38FD59AD82EF,$BEF84F1DFACDD7E8,$6407BE45CC0000A6,$001DF227FD145BD2
            Data.q $A5E37E47C6A3B280,$395EA7B1F13B5E63,$92F6BDD8E28D8E27,$E9243A54B1C46F76,$349F242A48174946
            Data.q $00EEC6DF7BBA2369,$AE58746C52A56B42,$7738D881F494BDB3,$94AE5C60F87A6110,$104C09CB6851B104
            Data.q $BB0559AF0563A797,$2C90AB241046C9CA,$773ACB83F3E34B6B,$84057C8F680000D5,$00003BE433ADF279
            Data.q $E62BF58996E36665,$6DCC27B45164B45F,$57FFDF4C270ECAC1,$9095A4309776E0AB,$92A976F285516DF4
            Data.q $0559ADCA991582DB,$03930D43D3BFDC63,$AF5B66D65A6DB30E,$D920FC82AD23E4B2,$2B1FABAA3E549596
            Data.q $61FDBB5C51D91E8F,$EF88D8FA0012D7DF,$2D80BE99C1C4FA00,$98CBA03174C1ED58,$1785A4E33B9E5B8D
            Data.q $7A2349040E170C8E,$E8AC96DD0C2437BE,$504849CA5FF0AB51,$AA928A36208B5572,$48C9A560B794D145
            Data.q $586D92956EB6E328,$D91F7DCA88B67726,$60A361F9E37CABE4,$0AAF939AD8105197,$BEFA4FA20BC5A305
            Data.q $1AD2C1D8E7D00086,$A0C818DBFB20254D,$75A2A980001DF319,$903E8BE9C37DEEDB,$5462903EE58481F5
            Data.q $E156DDD1B7BA1850,$BD2D3D2405454D0F,$87F5C65929E50A68,$5CAB24C6EA69E944,$E5B628913E9208FD
            Data.q $7C300F4999348F9E,$ABAA3E572C982ADC,$E2745372311F471F,$73E8003F5F7D7BD6,$A83ADB198D6960EC
            Data.q $C352E815D707B480,$FE1653CCE57C771B,$BFE92125C9015661,$72F455B3745582C3,$41B4DBE54C88F939
            Data.q $7F9308E55642A8BD,$E4D2AEDBA77FB947,$AB2557ADB2564D23,$08FBEB3E29AE23C2,$DE90B2F963F5456C
            Data.q $F1AD202A3F68000F,$1F4CA0FD505F4CCA,$92D8BA0101506B48,$8DD8DC7B5B1F43DD,$B918AB7020AC64E9
            Data.q $85054B155918A4A4,$648F92E70E8AB4DF,$51212B48D55A6F24,$9BD51D2E7E9E54D2,$2AF53F24333D2E7D
            Data.q $E5AF85184F8482A9,$2D3127A0A726EDC7,$0EFDB35C2BBC525F,$90150006000CD7DF,$20536A5202BA68D6
            Data.q $8B998BA0101E8683,$CBDDEF3B1F5694B7,$1E80D7428AED0E97,$7ED1468484675585,$549A6EDC64D6F0AB
            Data.q $CAF5B72941E7CD24,$4A0951396D782326,$6CDED8DCA3EBE2A6,$EC6CD81F82AC960A,$CB202A4901EF986E
            Data.q $20CE8000FD530F97,$40541A0B198D6901,$CF4C0000EF8963DA,$9DE7EBC9FF65B09C,$6E909F2FEC1A3A37
            Data.q $B1EE29092E7A435C,$AD9286204E5BBE8A,$4AAADCE2B25B1557,$36C4B89648AAD23A,$E83C28DA7C23F73B
            Data.q $285BBF192082517A,$DAE2FEF15174BFBF,$20300056BEFBD76D,$D51A0B198D6B7E78,$F86832053681C809
            Data.q $3FB76B8A03D0300F,$0A8A257F0B4DFAFC,$C8C52126920AB4A5,$559EFC2AC0F4C6BA,$9112EB218AAE64F8
            Data.q $AADB921AB4ACD6FC,$20951396C8AB1A15,$D1E1480A93D51A4E,$23E8FBFC579D2729,$0C00122FBE332E87
            Data.q $5F4CDF635ADF9E0E,$C8680DF8CC809D50,$F5A198D00003BE11,$06978594F33BAFDB,$327CF0469241B3F9
            Data.q $3A4BB1FC5469DE12,$B1559ADF9222498A,$5969E536308F12E4,$51BCF8519023E4B9,$A79E3692DAB94AF8
            Data.q $AFA2BB478E16B013,$018001F5F7CABB6D,$13A6956FA16C48B1,$CA39A0C814DB1790,$ABB4F0B71A000077
            Data.q $0FE657799AC37F7F,$DEEFC64C30AFCC25,$5A799359B21E146E,$8E98A484E5C628F5,$CF4C3D51ACD92DEC
            Data.q $134B1EB1D3738903,$0A0901E923D55C8F,$1DF9A4FA1E8E2B46,$6B767843A000F2FA,$0A8F4CEA89F3199D
            Data.q $C680001DF6AC6B48,$8FFB7DE150F14919,$19370747E7BB5A18,$C6495256AC2DB923,$E150543854951958
            Data.q $8AC3AC6E7C3A4B1F,$B148D8AC52549255,$C6B258991967E4E2,$77621518C152C6C8,$FB061607762179E2
            Data.q $9B05BB91929782AC,$0D1BCD60A74DDF8D,$82EDE2BE0E1D0CF6,$7D0077DE39E0C000,$8F40202427880A84
            Data.q $05BAD2703DAF9B31,$55F20DEC179FCC17,$17A28C0C36FCA890,$3084393D29B4C2AC,$A447B97146EDC64C
            Data.q $6592684C1C9B39FC,$125957A9B26E3E15,$A7F0F4795901EB92,$0009AFBE132DC6CD,$7CC6675ADD9E100C
            Data.q $0640A6DBD9013AA2,$887A0084BDB902CD,$F0B29E6753CB6139,$E94D66113B21E1A2,$B8F8AAD0C2B2DB95
            Data.q $0AA2C1D0F944F455,$F9FC9A140767EF15,$BD82AC57ABD6C920,$60F87CA160F07CB6,$7E1DEC291D1A3050
            Data.q $18000B5F7C17C0ED,$AE9A47D0077C6B30,$A5110640A6D0BC80,$71DDB76B8507A03C,$7A4A71543F8B29E6
            Data.q $FDD1568486AB36F2,$8F8CF4C5568BD156,$9D9321CAACF394E4,$4D278245FAE61EA2,$82DBDC3E4B88E676
            Data.q $3FE1F2C568D6B235,$E8004244C4DEA737,$3166AF635ADB9E2C,$180000ED46D5D986,$F6F9F754414449FB
            Data.q $6A3D01E5289032C4,$F6335C6DCFB6E374,$6486AB94549B74B9,$F455AF7455ACB1DB,$FCDE48D9BC51D4EA
            Data.q $FF85184C14632BD6,$DA47AAB9855DB6EA,$0E8B1E5F64343207,$8803000FDFF7D67F,$0915376868D6B6E7
            Data.q $88EC3D034990FB48,$9DF0F47B1D0F91B1,$D313B2AF5B70592E,$72FB82AD87FBC90B,$30C260E4AF57A527
            Data.q $55CABD6C93D90FED,$4715A3055829B23E,$5856CB5DD66E5C8C,$41DF4AD240ACE800,$DBD09A09728689F4
            Data.q $D99ECC0000EF9D67,$5C2EF31584E265B8,$C2417AE613DA20BC,$C57ACD6D920B9DD0,$18D0901CF2A07A2A
            Data.q $6C382AC6586DF905,$F2728ED526C8FE15,$933430DDE8DC1411,$00DDFF7C67E163E3,$655A403389568030
            Data.q $A0C810DAE7901556,$ACC6E6000077C53A,$46F3F1DAFD77B2D9,$DD0C28C0C2070A86,$EE2907ECA830A9D6
            Data.q $656126CDA1FA282D,$39F07839260558CB,$11F2657F7E90B0A3,$3985743A5C8E8C14,$180066FFBE53CB61
            Data.q $556647D0077C9B40,$8A49273ADFF4A101,$5B35A26E6001077C,$A28BEFF986EA77BF,$4E4EE488972C56F2
            Data.q $9297C2AC27C28D0F,$51943CF53E530FBE,$DC3F57CF9E0AB258,$63A3481047C9A6F7,$50180056FFBE53E6
            Data.q $012ACC8FA00EF9A7,$A40CB1F5BFB49099,$B75C50BE80415440,$B67EFF8C270DCAED,$48C9D51CBD702B0D
            Data.q $E769F2D5F0AB03F8,$91124DED62264981,$C1428F9348FD5CB0,$AE6B8A6BA1A2E968,$6A030009DFF7D07E
            Data.q $75134348FA00EFB3,$81C5A67A491013AB,$35A000077C73B20C,$91A8F2BA5D123DE6,$9A7EF67A535CC3EB
            Data.q $9C3C28CC7C28C890,$5F705F0883923F56,$9A3101EE5572DF97,$587E0001FAA23F3F,$69EC8FA20EFB6749
            Data.q $1C5BBB20256A8BE4,$B40000EFAB7B20C8,$A1D2F9694B78B986,$915070F8A0BC5A5F,$70C290E490552478
            Data.q $A5EB05B72A7A2AD2,$9FA770F952560B64,$8FCE168D60A444BB,$BFEF97755F570CEE,$BEE34966D406000F
            Data.q $202411E50D23E883,$7A00C6BED526F5ED,$198EE3FECB613990,$2D920FEED8646F3E,$3C3D353F91526958
            Data.q $D17AC34C9F3E1560,$E90B0703D30ABC4D,$3E0F1C2C84972BF6,$66F6018002EFFBE9,$3F20275999F401DF
            Data.q $03E8816C83207168,$D5AEEB61398AFA01,$4D296C0A3BBE8CC7,$3055709B22E4D22C,$59349DDD8C9C7F0A
            Data.q $E6424BA0F07CA3C5,$EF5DB76B0B3B858D,$DF16F60180026FFB,$BC97B06ABD91F401,$BC0CB1B5ABB20256
            Data.q $13C2B5A000077D73,$82C7C8C56AB8DFB7,$B15E6A9E906F3464,$A9ADCE1AAA57828C,$E329F87E7F357ED8
            Data.q $7A4815C180018FFB,$0439C348FA20EFA3,$43E81ACC8FDAB05B,$874B51E1FFB71B23,$55EA8D55CA1412BF
            Data.q $6079F27655AB6EB0,$F6C32346B054AD64,$77FDF75F0BCF68A9,$77CC692CDB00C000,$A9D6A404E1A47D10
            Data.q $AB42EF449525BB8F,$E39E83A490D259BC,$303F8793E362D000,$37260727F13C2F31,$F24C6339F15C71C7
            Data.q $BDD6B24632325936,$6DBE6CDA7E1E3F9D,$CFD2490000DC47D2,$51C6DC34CFA00EF9,$D0B423835098C92B
            Data.q $80041DF36F493190,$4164B03DAF9B33D6,$1AE42F9F6450E170,$B8F92B15562DD3CC,$C2DEE1BD9A1452B5
            Data.q $E7EE03000FC77C17,$5545DE1A67D0077D,$B9C08145B3B1CAAF,$D9ACC3DA000077D0,$C0830BA1D2E967B6
            Data.q $EA3EF3E556EDB84E,$E7353FC2C60B2525,$2F1CFE000A2AA16C,$1BFB99F441DF24E9,$0A2D7DC8097AC2FD
            Data.q $6FA03696C53BCE04,$E892D96BBAAFAB85,$587497208E13AA37,$2E1C1CBED0B1F723,$A8E03000CC77D67C
            Data.q $FD1B07A484D6B47E,$589ADCFFC50F7AE2,$5AFA07454E265890,$BFC3C70BE5DB66B4,$5FB7955DB65346B0
            Data.q $6E3660BE0A1BCD19,$2EE03000BC77D179,$C3525FB99F401DF0,$586D873A40548D7D,$4647E2F73E2B9F40
            Data.q $E4709655ACDB8247,$8CFC9C30899AC157,$E3132DC0600138EF,$BD717CCD7BED5B77,$3AD044C3B929E404
            Data.q $BCCD7D0161B628BF,$28AEF062D1C9B6E5,$5918CB652B584FB4,$AFAB30AF6C3C3463,$78B175F80007C866
            Data.q $A78BE66A7FB56B26,$3128EB5A4154F8BB,$BD96CD667BE80B0D,$6B01D1ACF3C346F3,$64520A152B0FFE92
            Data.q $EF40001F1DF69F0B,$986F2A6A1F401DF3,$BC868294AA69012E,$B09CCFDA000077D7,$A0A1497070E8E765
            Data.q $9ACC6BDA1455FB6C,$E2DA0001E8370D2D,$4CCFA20EFBA74924,$4D2025D3BA09C9AA,$DCB4905F90D05295
            Data.q $75BB582FDA001077,$C220F4DDF858B15B,$D00004C77CA7D028,$0B541E87D0077D87,$7CB56629255EDC0F
            Data.q $8B0F4000F7135EFD,$3C4F5745C8F6BD25,$D00002C77CB7D17C,$BF60B3FFC8AF4902,$57D34826E66DBFAD
            Data.q $7EF0EDE88D109E40,$919FB40020EF9149,$F11F56849703D814,$E23497EF40000B1D,$C0FF569DF43E883B
            Data.q $EFF5C7EAAB3FE41B,$139800000009B99B,$C7EC067FF949E92B,$EEC8234CCD4F74D5,$0A1ABC21A207F669
            Data.q $D2B494EF39D00000,$8421DCA0E87D1077,$054979690129994D,$041DF6CE924DA492,$F6DFC5E080C00000
            Data.q $53353D01389A9EF8,$C1C2ACD2A4977202,$800000003BEA3E4C,$D1077D9BD249B001,$8094CD37CD98EEA7
            Data.q $BFC8682ACA2CD3EC,$F68000000D459B93,$D9D6EC7D0077D4B9,$9B32DFD0C723537C,$3BEDBF4959198C1F
            Data.q $DC8A763E80000008,$CE774949BD68BE8B,$D9956640491B1BE6,$1077D13A4B1721A0,$03BEE3EA7D000000
            Data.q $DF36797A4AF763E8,$6903E8A7720248D8,$400000323A712B17,$DB74ED1FAA259C1B,$5C9F640491B1BF6C
            Data.q $F26F497CE3DA3B87,$63F99F400000041D,$6A92EF59B9F401DF,$3FB76903E8910124,$D300000002F7E356
            Data.q $8FA20EF8E74905FB,$F7A1FC6A43FFBACD,$4974E43402FED986,$1F400000041DF1EF,$D243BB76F716C488
            Data.q $1DC809A3737ED981,$1A49973ED0B15B72,$FB8F400000041DF3,$5DCFA20EFBC7494D,$2575F8342E6F973D
            Data.q $C32FCB994E2B33B9,$77C9BA490D25C6B4,$A4956A3D00000020,$FF77E8E39E85252B,$FA66E6FDB34BD249
            Data.q $29BF21A0E994E60E,$FBCD0000000B1DB7,$F773E883BE23492B,$0499A03F2E6A7A49,$9865F973134946E4
            Data.q $000E90D179F49591,$BE33F4945FACD000,$BA344A2E73001883,$AD25EBC7C9724B05,$B4948EB4C52FEB99
            Data.q $000002077DB7D25F,$51A486FA481623D0,$B9E922FF800C81DF,$6D598A4BF7C2FE4E,$027BC1B2B4913F5F
            Data.q $CFFF2F3EE8300000,$4C86F46F1EB0836F,$FDCDC8D73EADD9A7,$000461EDC98D7B45,$3922F728DEF4C000
            Data.q $FC837C5FAF9B6FDA,$7BC1B57EB2835F67,$3D24C68830000002,$3536B2836CCFFF26,$C8060D3DEF5A5B76
            Data.q $DD8DD5A489FAFB9A,$F277F38180000016,$EF0681EB2836BCFF,$E687696D33668CC9,$AB6926329A21F270
            Data.q $3FED500000072718,$C0086ED5F19D0B24,$DD8DCBEB48361677,$A4BA708180000016,$F796906D19FFE557
            Data.q $D06117FF21DFE5D3,$000000CEE86E7FD6,$3F7C98D37245B7F4,$A6774356FAD20D9B,$318BFF923F4902CD
            Data.q $39B91BB3A490EB48,$48818ACA7D000000,$E13A737237AFD63E,$50FD6D06317FF233,$4000000E6E4692D2
            Data.q $DA0D8F3FFC84FA1F,$8A70AEC7A0EE557A,$8A4AB75C41905FFC,$E4FD0000003FB81A,$F7F5C41B0E7FF97C
            Data.q $5FFCAEFA4E9CDC8D,$000010A7DE5C4194,$FF915E9259D07400,$FEE068EF5C41B067,$F4961FEFC730A534
            Data.q $AE59394D0408AD33,$00000081DF56E70F,$EF9A4877490AD9B4,$47FFA49CF401903B,$BD24CB792077C952
            Data.q $9E5FAEA0D999FF26,$71ACF400000116F9,$5D41AE67FF97DF49,$FE5DB1F916F9999F,$9DCE9243AEA0CE2F
            Data.q $489CF400000116F9,$AF20D6F3FFC83FD2,$FF95CE4F25DE330D,$0081B925EBC8338B,$AF838AC2FD000000
            Data.q $3D9E4BBC675BAF7D,$4ABFD7906917FF20,$D0000004BBC6713A,$7D06AF9FFE46FE1B,$F2FDECF25DE33F9D
            Data.q $10922D3D7D06917F,$9FFE5CFEFBD00000,$EA8557263D7D06AB,$358BFF905E92436A,$0000163B6247EBE8
            Data.q $79FFE5E7D2564DE8,$D755EE19D7FD258A,$044B962C5FFCB4F8,$740000015EE19ACF,$89FACB747CF44093
            Data.q $2314AC99F3E4E8BA,$D38DE924BD65BB79,$8910AE8000002EDF,$DBFA6AFEB4DDAAA9,$E58D17FF26BE7DD5
            Data.q $02EDFD3EDE922BD6,$F20DD2446AF00000,$B5A4B0EB72C4DCFF,$702E41B42EB1DED3,$FF4921D6E58F17DF
            Data.q $C7E00000063BDA6E,$58979FBEAF51B902,$DB1758EF69D5F5E5,$25875E558F17FF22,$40000018EF6997FD
            Data.q $EADB7438C714AD67,$80BFF924EA47EAC9,$D4E303D52FEBA9AC,$59E92CDBDF400000,$4DAFAE5562367FF9
            Data.q $88BFF956C17AD377,$0096BDB95AEBA9AC,$EAA7D72F9C3E0000,$B5CB0EB9558899FB,$B242FFE453B4F452
            Data.q $CEF7555A4AEFAF6A,$BD137FC7B4000001,$D6FB9A7EFEBADDC2,$3105EBBDD6A71853,$D898C67400000B21
            Data.q $450B5CB0EBCDD31D,$0EBCDDB96445385F,$0000085F44FFFA4B,$E7FF921E920D9F68,$D51FBDF3D5FD561E
            Data.q $75FA6B2A2FFE5EFE,$0000206EF515A4AB,$FFCAAF4967FD2CC0,$3C3D4D7AFEAB0EB3,$BDE8E9C5139EAAF9
            Data.q $80000085E7105EB0,$F3F7C6F8372258D6,$61EE7577F5E66B0D,$C6ACB8BFF93BFBCF,$60000059298ADFD6
            Data.q $3ACAF6EC462EDEF6,$0FEE4AB44C1E3EA4,$E447AD8D59917DF4,$922A3400000373E6,$7C6AC31CFFF2C7F4
            Data.q $0E8501D93BCD65FD,$BB3A4B16927D8EFC,$AFD258B7730BBF03,$D59AE4B7C90FFDCA,$F5D25B39EA000001
            Data.q $5FB61A081DF3CE92,$45ADF4B2677245D2,$73563D33BE067D72,$009FB8D4E74921EB,$9EA60F5572230000
            Data.q $5F67EE351FFADEF6,$D7E6ACD8BFF94DFA,$001BC3372E7F4961,$F971E926DE924000,$34949EBF35614E7F
            Data.q $0FD240A7F696F534,$969EB766B3A2FFE4,$1800002AEE538BF4,$7EBEBD0B31C52B24,$FF2F3F73ED5DCA79
            Data.q $9B496DF5B7359D17,$436BE800002C6FAA,$D7D7A3D738A7FE92,$FE5DB8A0EC6FAA77,$FFA4B0EB6E6B3E2F
            Data.q $24000006DD1E3EA3,$C76DB72ABF2C1DB9,$7B606BEE6B07F3F7,$1D65FB09C389377B,$0000128E9257F492
            Data.q $FDF7E78DCB1737E8,$DC069AFACD6AC1BC,$5EB75AB026FFE5A7,$5E80000112E9EE4D,$0BE7FF95DF490EF7
            Data.q $80D32D258FD6EB56,$24BD71FA1393111B,$D7A000005C743FB7,$13CFDF300CEE59BC,$9FA4920BF7AFD6AC
            Data.q $497ACF6AC19BFF91,$BA00002CD6C4A7D2,$7FF96DF4121B959D,$E150A3FD67B5607E,$875BED58537FF26B
            Data.q $8000015AD25E7D24,$FF243F9735C9126E,$289D8B3EF6AC0BCF,$CDF7CD27B7265854,$490DF4961D77B561
            Data.q $F8000005A57B94EF,$FF959E9265D242B1,$9A8427D7FB5603E7,$F5B9D58737FF2FDE,$0000B96921FFA4A4
            Data.q $B574976F49582740,$9D58059FBE828BDC,$B5C750BA55C90F59,$25875D9D58937FF2,$00098D247BD2537D
            Data.q $F4919F4926DAB400,$EBB3AB3EFFFFFCB4,$F4932D6985D3A490,$55EB3F2C59BFF923,$04781DC877A07EB9
            Data.q $034EDC9567660000,$62EABFFD7B063B7A,$84AB94EF390077C6,$ADA4A57495EDB060,$001C37E93490EE92
            Data.q $FA4BE7494ADEBA00,$29DCC8D749F00D25,$4F52077C9524A7E9,$7E9237F492202537,$DD24FB1AE81077DD
            Data.q $70DFBF76F27B6928,$8E92E49B1AE80000,$7497ED941B56C40B,$6EAD31C73C27A4AA,$6C64DE4EE446404B
            Data.q $3FD25BBA484DAA2B,$00C7C93DD245BA48,$7C0A0EE52B041800,$DB50B6B389B7A4AB,$E9331077C97D257B
            Data.q $861DCB36924404B6,$C4AE4073A6002F43,$7B2425C8EFA4B778,$92046B40000446BD,$7A49D7A49674924E
            Data.q $B82F42235ED5A493,$6E88D1077CBBD24A,$EF99753CD724404C,$BE444B909E73D020,$1019F01D64DEE923
            Data.q $9C6C972D580D0000,$88D790D25D3DBC99,$17A4B274919E6BD0,$AC404D6E88D2077D,$E82077D1BD25DBA4
            Data.q $E9283D25BB492569,$FA2A3FEF240F4961,$5426E5659D000049,$5572F5A48369289D,$7D0B0BFB8D25138E
            Data.q $B7427BD45B72ADE2,$88BFE92FFB922026,$23DA49F63DA252FF,$B979E92D3D64A9E9,$4FBE9F3E4C5E0E57
            Data.q $28B49225A80002B2,$A474922FEF720B59,$E5ED8B96BA46DF5C,$41DF51F4923F8F68,$521DC910139BA334
            Data.q $E495E06041DF65F7,$4949919395499092,$5649D000088B7B2F,$237403B9234417E5,$6DCBF74F8039E1B9
            Data.q $809EDD3CC1A9EBDD,$0020EF8F79012E48,$F25CB2F22E800000,$090BD59A40EFB0F1,$077C53AC54DC88C8
            Data.q $C977897400000002,$0D0077D639EABE4D,$001F0FB122E92038,$268F513FA4900000,$4BE75240546F521F
            Data.q $800000001077DABA,$6A3F5C8B7A4A7747,$C88F09A00EF82A4F,$000081DF1BFD7C35,$EA6DE9233C1E0000
            Data.q $DC910154BD419DF1,$2077DDBD241BB196,$9DC84D0740000000,$17AAE640EFA771F7,$D2457E924AF2407A
            Data.q $1D0000000081DF2E,$5EF521F241F561F4,$F26CFD257B492202,$207F77E800000016,$B6BD2AD1077DAFE9
            Data.q $F5CAB7491CEF2B05,$8768FD0000000085,$D4BD4AD1077D0BA4,$8DCB769287ED5E84,$3DCDFA00000005E8
            Data.q $2B481DF35F609372,$7497DF49220272F5,$D0000000001A6E48,$BE4BD2573A49762F,$D724404F5EB56903
            Data.q $0071CF26D24AB38C,$05EE5FB0AD000000,$90FD0ED2077D27F6,$B4934E92B5D24880,$1CC00000002077CE
            Data.q $77D77D256FF4901C,$22D5E84DCBD2ED20,$00081DF5CE4233B9,$4E7E92130B300000,$1C5EA76903BECDD2
            Data.q $9AE40BA484CF5BC3,$92525E8000000075,$AFEA43E4F3EA4BF4,$771ACB965E924404,$C268000000040EFA
            Data.q $E84E883BE6DA49AF,$B4FE1407724404B7,$E1BD0000001D2D38,$F4A7441DF72E92C3,$AB7A48CF49220263
            Data.q $0000000103BE3DA4,$441DF33FA4A971A6,$25AB2D7A1353F527,$000081DF32D24B7D,$F98FA4B7FE550000
            Data.q $A491013DFAD3A20E,$40EF91692EDD2493,$7D2567C480000000,$2202420C3E1077D0,$7DC692BFFA496749
            Data.q $45F7818000000207,$92832F841DF3EF49,$1909CEE51BD24880,$D606000000081DF3,$903BBB1B912E9215
            Data.q $1AE53B96BD09B5FA,$000000040EF9F7D3,$1A43E4F01A0BE903,$94FE1487724404AC,$80000002077DE7A4
            Data.q $740C7D677217F281,$F74922025E0D21F2,$00040EF8CF2125CB,$C87D240FE1030000,$4910131062DD1077
            Data.q $39E13D241BD2587A,$254BB7F40000000E,$6A41937441DF77FD,$DA4A6FA48565AF42,$95F4000000103BE0
            Data.q $81DF13FA4A8FA492,$816924404F419B74,$000E39ECDE92EDA4,$E6CD728387F40000,$077C151BA40EF957
            Data.q $E3A49AFA4A0E05D0,$0000001639E29D24,$4DD25A7E92BDB6F4,$61CE202456E903BE,$0007506B95882AB9
            Data.q $9AAEDCA8F59A0000,$548091ABA38E7BEF,$C1A9DE9293D24DBA,$EEF340000007D06D,$F119D5A4C56FF490
            Data.q $2F66CAE517D53D90,$E1BD000000038E7A,$200D8FCF07C9722B,$F493AF4916EDA901,$B5D000000040EFA0
            Data.q $C27CE1AE4B7E924A,$1BD35829833D2C73,$040EFBE74955F493,$77A49F655D000000,$BD3203D1A6F3668B
            Data.q $7937A75DCA574909,$61E1DD000000058E,$7A40EF8F74956F49,$CAB74962CCC80911,$70DF914939F8334D
            Data.q $DE9235D1E0000000,$C6901E8D67CD9A21,$000BC65CA674936D,$92DBF49252C18000,$8D3D2C73DFB4902E
            Data.q $923FFA4B8DE6901E,$E80000002077DE7E,$7D1BA48AFD251788,$43BCD582D80FD207,$22DE926BD25EFE92
            Data.q $3DF67E8000003892,$FD2077D7BA4AE749,$94DCBB79B9E78782,$4000000103BE25AC,$F41D2407D2497DCB
            Data.q $6E6E6407A13F481D,$02077D9BA4AA7492,$B6772FD996800000,$C16C72D1F2457BC7,$57A4B2FA489FBB9A
            Data.q $800000535C59BD24,$BB74969FA497765E,$EB5AB05B15FA40EF,$040EFA27592DB974,$5FFA49294D000000
            Data.q $FA58E7A4D24F7E92,$FE92B3D6B7D6AF1A,$058E78674952D24E,$BCEE4A798D000000,$7A23682225CB2FB7
            Data.q $79D2B35C80EF5A40,$776E8000001A80E2,$03A15EB6E593A4B9,$25EB493AE7DA4048,$980000002077CE7D
            Data.q $E28FFA4AB7A4B762,$FDAF6901228EC160,$39E5DA48B790D572,$7F562DB800000016,$032C73C5B8F55724
            Data.q $E7D24278CE901E89,$003F12275E924525,$AE5F3A4A761F0000,$A62C0CB1CF35F767,$D246FE92E9DE7560
            Data.q $880C00000081DF66,$4D25BFF4932E9283,$BCE90151E0658E78,$BD24E7A4ADFD2567,$00000070DF90D251
            Data.q $91AEAE137275DAFA,$DF1015102C73D874,$3BEF7FA4B4FA4996,$A494F33E80000010,$202422E81E25C90F
            Data.q $26D254FE924DE1DD,$83B8F400000081DF,$808F1DC997E64D72,$5CA4F0EEAC16C32E,$E23496CE9273FA93
            Data.q $43B49E8000001C37,$AEF3268AB69205D2,$7BF4902CFBA40545,$002C73C0A493FE92,$56EDB941E0BD0000
            Data.q $6BDD202401EDD58C,$40EFAE74973FA483,$97493ED4BA000000,$41639E93496BFA4A,$7B72F9DFBA404883
            Data.q $400000081DF24F18,$293E92B3E9283897,$901224D058E7AF69,$6B35B72C5D2560DE,$997C00000058E7B5
            Data.q $C67A484FA4B97494,$12DE901225982C73,$85692E3E920FFA48,$24A63A00000050DF,$639EDDA067B90AE9
            Data.q $B921A6F480911CC1,$000896772EFFF526,$B1E7D721DABF4000,$DE90120D682077D3,$C7492DF911572436
            Data.q $2665A00000050DFB,$85709B929F1E2AE5,$5FA4AC1FD202423E,$058E7BA74931F490,$9CFA480EB6600000
            Data.q $B41639E3DA48CFA4,$225C9B79FF480909,$3400000081DF36F2,$F56C9B953FA4AF68,$FD202466D058E7A2
            Data.q $4965FA4B0FA4936B,$D96A00000058E791,$1FAAE457D9EE7729,$A4996FFD20240018,$C73DCB4941F4975F
            Data.q $5CBD749250000002,$1203C0B1CF66E3C5,$507C89F5C911C190,$83000001639E39D2,$494BFA4A2FA49F67
            Data.q $0640489F0286FCBB,$247BD2437E9229D3,$B7F40000058E798D,$9DCBAFA495FD247B,$C6D8320247018E60
            Data.q $73C93A4A0F9092E4,$4B901C7FA000002C,$41639E7DD252FE38,$DE928DEA41012197,$0058E7816B4DB72B
            Data.q $E557D25BBA6F4000,$8A5D058E79F7CA9A,$7490EF4922D50404,$00005A098A77A489,$C1DCB2FA4A8F7A60
            Data.q $02401E82C73DBB81,$912E4455CB8CE982,$0000010F03B926F4,$F74955F562DB939E,$8D0404863D058E7A
            Data.q $1DC9E7497CE92E5A,$D000001C37E43872,$A4B57490ED24BB61,$01234D02E9C6E4BB,$174919FA488C6CC1
            Data.q $001C37E25AD76DC8,$DB5609B92506D000,$A0E1BF61E9235D25,$035CACAE6080905F,$86FC9B2525CACFFB
            Data.q $B74945E0E6000003,$F79E9275D241BA48,$6D5A080911FA0E1B,$15CE92B3F2225CB9,$6E4959BA000011D5
            Data.q $F15721BE928DEE4C,$ED04048ADA156B60,$5BD2573917CEE564,$000446BDC7D91AE5,$D241FE3955CA7600
            Data.q $04048C3A2E5C621D,$E484E55D3A48149D,$3ED00000127EB91C,$4DB8E12E4DBA4A8F,$C9F020246782AB6C
            Data.q $4BAF492CE920DA4A,$800000A897249EDE,$723BF71637273DE6,$19740E1511EEA9DB,$F646B9219B741012
            Data.q $289CA097219D24B3,$997400005067CC69,$94ED5326E427A492,$98C794F495EE384B,$94AC57A080908680
            Data.q $6D692F5A4836444B,$D00001419F32FEF2,$AC9C3C6FE7721366,$602E31E83FDEE7EF,$AD24C6EBD04048D6
            Data.q $2B25C8D6B27C7496,$2566E8000272A2E9,$B4929E2E55C8CF49,$F6925DDBC963D25B,$F410120F680D0BF8
            Data.q $BC955A48569205BB,$2517C7C951D2463D,$2B400078869F7D2B,$7DADCC5E2EFAE494,$F1525CA1FA4AF692
            Data.q $7A4D24E7AA16DC94,$8B28040484F01289,$D251FAE446484E54,$0FDEE6D6F24164A4,$A4A4DDFA00058544
            Data.q $7B903A4A0FF79397,$D8E93E46C9CAA0FF,$000000000118E1DF,$BA3D17913FFF2D40,$00000000A2919288
            Data.q $826042AE444E4549
      EndDataSection
      DataSection
            Expand:
            ; size : 1637 bytes
            Data.q $0A1A0A0D474E5089,$524448490D000000,$4000000040000000,$7169AA0000000608,$4144492C060000DE
            Data.q $1D684D5AED5E7854,$9263FA5E673E1455,$2155820369A62D26,$2910BB0BB434AC50,$5C410441222D262A
            Data.q $2A2A1487F0B88794,$5D50B6A8B8952974,$4C11068C1052E8B8,$24B52B4B5E60DB40,$2698854692B46918
            Data.q $77936D31AF26988F,$FCC9E38E4EE677BC,$B9E97CE8B36E74BC,$77CEFBE66130CCF7,$21913BB85CD7BCEE
            Data.q $90C86432190C8643,$475FC7E26DC20321,$77A60EAC2369AA77,$5D24802FB41B6F37,$96D8A80E2A83A6AF
            Data.q $D31C541142B4F296,$78AE005766B8C4A1,$9C50AB89C9F55F9F,$928C6D1E8C278898,$8691409424C8009D
            Data.q $42BFE5B8DCD846C6,$97F252B811D4ADEC,$2E14FB3E2F827E86,$D86EE4E941643CFD,$611785EE780EF0FE
            Data.q $6856022456478EFB,$0B7D4FEFF96D01FB,$AF18D202BE389C9F,$BD795E3142A19904,$585C5829E27F1E03
            Data.q $FEFB58F6FE8D8E28,$D9F743A016D25FB6,$CA8EA1F0E04657EF,$92310936A45623C8,$81FFB871E8E47109
            Data.q $C8D8C2CFEC726107,$E0621D7F3E7CB6E5,$4B1F6DA1501C7240,$005B0A8EA038991C,$756CFC808121E0FD
            Data.q $40241B53516DEE9B,$CE1F84EB8B472415,$83031DBA863AA827,$A83B93D7F2D13BAC,$A9EEEB6CFC09D431
            Data.q $0D203BC5740235AE,$2055357031F3AA88,$21487E88EEA43457,$A8D516E94748C9CC,$27527004816FABA9
            Data.q $03048634827F5F2F,$5DCD437442210C58,$E4EAA6B5573EDAF7,$3C89600AC50F93C9,$5100530E90501C57
            Data.q $68F3825A251C6188,$E2B07C89600AC6D4,$7084256013F10152,$02DFB0310ED210DD,$F379FBCC5451E4E1
            Data.q $9AF41F54E7A1B7AD,$9E0C404EF73AB950,$E1FABF6E70443618,$6A6A6A64060499E4,$6F3A178E38221C82
            Data.q $0442ACB1C98FB7DD,$FD6900E5AB800ED1,$DC4373EE0FE17920,$A4DF58842F8E1D41,$149DE04ACA2CE608
            Data.q $849839BA31024100,$C8E5E81B9C81DA4F,$C0B9A90894693775,$4BE0791818FAA349,$B93016E79578D703
            Data.q $9ED00BB84622EF13,$48B9C86D21844C00,$E72371DC4F9103F8,$5C22BDA2508519E8,$1E54DC40145A39C0
            Data.q $7A67C2CC550ADB49,$CAEEA29C8EFE439F,$AF8448429016FDA3,$4E157D5C73FDBEDE,$CF206E205C426B88
            Data.q $472C24DE4865FAA5,$73F6FBADF3DEA438,$3C88EFD339921B9F,$CF670A08899A906B,$3265CA082ACA9941
            Data.q $0DF3DBDE55161973,$524C484813BF7D1C,$5B2DED5E480E3B78,$F26057DEE0CD789B,$E0866F2017F3FB01
            Data.q $3120DB5BA7F3A07A,$F0609352B80082D0,$1AFF7D6C832B3DFB,$77038558220CAB94,$0475E15401AF9237
            Data.q $893407A4C77A109C,$9566A87302E6CBCA,$27B254A94907FC87,$9ECE1EDB10221A40,$0600BFA0EBAD77E9
            Data.q $6C36EA19B9B9BF7B,$BC5E2E111937B258,$AB9C822DE47C2EE8,$049641890FDFD338,$D5DDD04E656C9200
            Data.q $7C4FDF9FF2E206E5,$1EBDCBB5DAEC31F4,$2AF6BC6FE55E54D1,$A6425394B42D82DF,$BBC59CDEB201C764
            Data.q $680735FF34178882,$2FF243FD17F6CFBC,$A08B5B1C513AE227,$7EC9192E23D0D0E8,$7426CF59522FC976
            Data.q $D1E486114C477F2E,$B9C90F96042400A6,$163765E3DC088C4C,$B58FD591905DFA97,$015611AA4012593F
            Data.q $E5135934C4820C1E,$45270A4F593E27C0,$7BEC806BBB005114,$0EBC0C040D5971EE,$0B6907099D574011
            Data.q $EC57A87D989DA212,$B8C8F55920BA403B,$B333B309D9F7A961,$11AE41FA5E4B1440,$E05D84E02EC01DF6
            Data.q $6EF893045F47709D,$79EDF0788A0A1428,$F585E4C8C8414CF6,$4BA37080527775E5,$5D97DDAE43BC3411
            Data.q $2B2324860AB7439F,$02D2AB04B13C924B,$90E63241440AD214,$3EC82F6330FC4803,$5A9A640896C01679
            Data.q $90483389883E5FF2,$B0222B004148EE17,$65AD97F04569881B,$336D88A027959544,$4022B79B99FE371A
            Data.q $A53E2408BC4D7575,$AE6931328C2823B2,$867B79B3E5EDB47A,$156EC11734F18058,$BFA7FD03DD1FBBED
            Data.q $10CEF1FFA086FF8B,$6D621E2626A4E161,$5177FD34A34D9FAF,$380E9A6AFE7CF9CF,$88170B2FF29787A6
            Data.q $E410973E0217063A,$367EA6718A1F6C86,$C6C1402D45536B8D,$2137ABDA6AD3B12E,$9513938A0479D87C
            Data.q $4C524D9529E2926E,$E683FBB9EFBBF0FE,$000C2E0797D3334A,$039FDA6F4072A740,$F91CB51BA9F455DA
            Data.q $385C15FD7EF438E0,$85CE12BD18FE0E7F,$61A63A13BE5F27A9,$3EB424F619DAA373,$2FBEEAD4D4D42CF3
            Data.q $2680C0010E0D0C8D,$F9F9CDFD64A36B6F,$C08481EFD7EBB59E,$F1108F642D29FFFF,$8FDF4C21275A61F2
            Data.q $061ADC2E2F0D0F0E,$5956C2CC43BC8380,$CEBEE9A1A6A4F5B5,$B750DEAF9E9B8DDA,$4842A1EB75DACD71
            Data.q $73F31BCDD6E395FA,$9F1AFF5753D333B3,$F264EFBE9B4E2A99,$637669D885200B69,$B37183AB0AD8A8B5
            Data.q $C8A4841F1147B381,$FC32190C86432190,$1688E99A127EF40B,$4E454900000000DD
            Data.b $44,$AE,$42,$60,$82
            
      EndDataSection
      DataSection
            collapse:
            ; size : 722 bytes
            Data.q $0A1A0A0D474E5089,$524448490D000000,$3000000030000000,$F902570000000608,$4144499902000087
            Data.q $1A8A5D5AED5E7854,$FB25F1115CB61041,$1A88A083F87F8820,$DC4139B20DEB02F5,$7B037823C0DCC413
            Data.q $1F47405E81BD104F,$E25F507D44743FC4,$2435A5CA4FE0F88B,$98699993326EEDBD,$AEBEFAC69E87A282
            Data.q $4593A74E06B0AA2A,$7F0024DF6CEAB164,$A814B80FB972E46E,$6D67254253820C66,$FB366C812E1B9B36
            Data.q $A07E03A837BC1E89,$C990218D56AD5A16,$92414822F050BE64,$BE7D3A74812BE7A4,$3A74EC792C45AAF9
            Data.q $159798E752A54835,$32648214E19E8D84,$68A53116CA1F15F9,$001960D0D05642C3,$9F93886311543AFE
            Data.q $1962975A12244805,$3776EDDEAE734EB5,$5C78F109C3C031EF,$D7AF4884A2425EEF,$162C4270F10EF36B
            Data.q $8DFBF7EF94335233,$CCD40CDA70F05ED7,$160791B8D060C191,$3E89F0E1C3201323,$7C0623468C80470B
            Data.q $045BC6FDC07D1A34,$C78C80C9E8891220,$499A5CAA623C0663,$3201CB867BA6DF7C,$72B870E1F0184C99
            Data.q $10862337C4944DA9,$28850A1F01996591,$3060A10CDFE4ABF8,$F0194E9D320335A8,$7E78F7230D868388
            Data.q $825A8F1E3B69C3C3,$10207C063366CEAF,$D42F2FFC160E20A8,$AE349FF7EFC13878,$D01F6D7E7CF9F9BA
            Data.q $C4FF3C10AE79BD3E,$96D0BE8F9F3E09C3,$3C166DA0D8B162C4,$D78270F30D9E322B,$8FA8C8FFD4E93DEB
            Data.q $F012AF8B5162EDEF,$ACA0015408B73C78,$BAAB0522A1162D14,$972EA811E6EDDB80,$D5DF3B42196ACFCB
            Data.q $D0AF37300EBB7127,$86EBD7AC094D650B,$895BEA68B0AF71DA,$4A0972E5C6D5AB57,$C66257BA5B528A80
            Data.q $A60399809301E996,$B66418F274E9C007,$01E768432D5B6DDB,$BD32A1281E96BA97,$C387017D4E86B290
            Data.q $7796A2AA4A31BAD1,$1FFBF815B73FDDBB,$BB02546EA7FD2971,$7410B8EBDFF62EDD,$7810000701C4496F
            Data.q $7ED311C84D9B0449,$4EEEEEE365C1AFBF,$C6667870E1DF21A8,$162B318855AB56AC,$832F000DD0771AC4
            Data.q $8001BA0D430BCC6E,$EC7E63A26DFD7CD0,$E1E7013F024C50A1,$00007E6EE26E3E49,$42AE444E45490000
            Data.b $60,$82
            
      EndDataSection
      
EndModule
; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; CursorPosition = 207
; FirstLine = 78
; Folding = DABEGOAAAGhQjRwgAAAAAA5AokkIUBhABqUVlkkICBRElq-
; Markers = 747
; EnableXP