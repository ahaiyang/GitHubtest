<GameFile>
  <PropertyGroup Name="HelpLayer" Type="Layer" ID="cf7c86aa-5ad4-4a50-9825-21b6fa93ad36" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="15" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="Panel_3" ActionTag="-161627772" Alpha="204" Tag="89" IconVisible="False" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="0" G="0" B="0" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Panel_layout" ActionTag="-1294334237" Tag="16" IconVisible="False" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="Image_bg" ActionTag="-1509069896" Tag="17" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="168.5000" RightMargin="168.5000" TopMargin="76.0000" BottomMargin="76.0000" LeftEage="311" RightEage="311" TopEage="187" BottomEage="187" Scale9OriginX="311" Scale9OriginY="187" Scale9Width="321" Scale9Height="194" ctype="ImageViewObjectData">
                <Size X="943.0000" Y="568.0000" />
                <Children>
                  <AbstractNodeData Name="title" ActionTag="-1398172596" Tag="18" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="355.0000" RightMargin="355.0000" TopMargin="11.6494" BottomMargin="492.3506" LeftEage="77" RightEage="77" TopEage="21" BottomEage="21" Scale9OriginX="77" Scale9OriginY="21" Scale9Width="79" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="233.0000" Y="64.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="471.5000" Y="524.3506" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.9232" />
                    <PreSize X="0.2471" Y="0.1127" />
                    <FileData Type="Normal" Path="mainscene/jl_hl_bangzhu.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_close" ActionTag="1089418915" Tag="19" IconVisible="False" LeftMargin="886.5413" RightMargin="12.4587" TopMargin="14.0505" BottomMargin="507.9495" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="14" Scale9Height="24" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="44.0000" Y="46.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="908.5413" Y="530.9495" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.9635" Y="0.9348" />
                    <PreSize X="0.0467" Y="0.0810" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Normal" Path="common/jl_close_x.png" Plist="" />
                    <PressedFileData Type="Normal" Path="common/jl_close_x.png" Plist="" />
                    <NormalFileData Type="Normal" Path="common/jl_close_x.png" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_help" ActionTag="1542578245" Tag="54" IconVisible="False" LeftMargin="20.3802" RightMargin="22.6199" TopMargin="97.5447" BottomMargin="20.4553" IsCustomSize="True" FontSize="24" LabelText="1、按照从A～K的顺序，将对应花色的扑克拖动到右侧对应区域内。四个区域都集齐K，游戏成功。&#xA;&#xA;2、你可以将纸牌移动到颜色相对的纸牌上" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="900.0000" Y="450.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="470.3802" Y="245.4553" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="195" G="174" B="139" />
                    <PrePosition X="0.4988" Y="0.4321" />
                    <PreSize X="0.9544" Y="0.7923" />
                    <FontResource Type="Normal" Path="font/DFYuanW7-GB2312.ttf" Plist="" />
                    <OutlineColor A="255" R="195" G="174" B="139" />
                    <ShadowColor A="255" R="195" G="174" B="139" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.7367" Y="0.7889" />
                <FileData Type="Normal" Path="common/jl_pnl2_diban.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>