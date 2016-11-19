<%@ Page Title="" Language="C#" MasterPageFile="~/SiteCommon.Master" AutoEventWireup="true" CodeBehind="Declareall.aspx.cs" Inherits="Web_Admin.Declareall" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="renderto" style=" height:500px;">
        <div style="background-color:#5a86b5;font-size:15pt;text-align:center;width:100%; border-radius:15px; color:#ffffff;">报关单查询</div>

        <div style="margin:5px 0px;">
            <asp:Label ID="LabCusno" runat="server" Text="客户编号："></asp:Label>
            <asp:TextBox ID="TxtCusno" runat="server" CssClass="input_text"></asp:TextBox>
            <asp:Label ID="LabKey" runat="server" Text="分KEY："></asp:Label>
            <asp:TextBox ID="TxtKey" runat="server" CssClass="input_text"></asp:TextBox>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="查&nbsp;&nbsp;&nbsp;&nbsp;询" CssClass="eisobutton" />
        </div>

        <asp:Label ID="lbl_msg1" runat="server" Text=""></asp:Label>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="GridView1_PageIndexChanging"
             CellPadding="3" ForeColor="Black" GridLines="Both" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" AllowPaging="True" PageSize="15">
             <AlternatingRowStyle BackColor="#CCCCCC" />
              <Columns>
                    <asp:BoundField DataField="DECLARATIONCODE" HeaderText="报关单号" >
                    </asp:BoundField>
                    <asp:BoundField DataField="TRADECODE" HeaderText="贸易方式" >
                    </asp:BoundField>
                    <asp:BoundField DataField="TRANSNAME" HeaderText="运输工具" >
                    </asp:BoundField>
                    <asp:BoundField DataField="GOODSNUM" HeaderText="件数">
                    </asp:BoundField>
                    <asp:BoundField DataField="GOODSGW" HeaderText="毛重" >
                    </asp:BoundField>
                  <asp:BoundField DataField="SHEETNUM" HeaderText="报关单张数" >
                    </asp:BoundField>
                  <asp:BoundField DataField="COMMODITYNUM" HeaderText="商品项数" >
                    </asp:BoundField>
                      <asp:BoundField DataField="CUSTOMSSTATUS" HeaderText="海关状态" >
                    </asp:BoundField>
                      <asp:BoundField DataField="MODIFYFLAG" HeaderText="删改单标志" >
                    </asp:BoundField>
                      <asp:BoundField DataField="PREDECLCODE" HeaderText="预制单编号" >
                    </asp:BoundField>
                      <asp:BoundField DataField="CUSNO" HeaderText="企业编号" >
                    </asp:BoundField>
                     <asp:BoundField DataField="OLDDECLARATIONCODE" HeaderText="旧报关单号" >
                    </asp:BoundField>
                   <asp:BoundField DataField="ISDEL" HeaderText="是否删除" >
                    </asp:BoundField>
                  <asp:BoundField DataField="DIVIDEREDISKEY" HeaderText="分KEY" >
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
                <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#808080" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
        </asp:GridView>
    
        <asp:Label ID="lbl_msg2" runat="server" Text=""></asp:Label>
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" OnPageIndexChanging="GridView2_PageIndexChanging"
            CellPadding="3" ForeColor="Black" GridLines="Both" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" AllowPaging="True" PageSize="15">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="DECLARATIONCODE" HeaderText="报关单号" >
                    </asp:BoundField>
                    <asp:BoundField DataField="TRADECODE" HeaderText="贸易方式" >
                    </asp:BoundField>
                    <asp:BoundField DataField="TRANSNAME" HeaderText="运输工具" >
                    </asp:BoundField>
                    <asp:BoundField DataField="GOODSNUM" HeaderText="件数">
                    </asp:BoundField>
                    <asp:BoundField DataField="GOODSGW" HeaderText="毛重" >
                    </asp:BoundField>

                  <asp:BoundField DataField="SHEETNUM" HeaderText="报关单张数" >
                    </asp:BoundField>
                  <asp:BoundField DataField="COMMODITYNUM" HeaderText="商品项数" >
                    </asp:BoundField>
                      <asp:BoundField DataField="CUSTOMSSTATUS" HeaderText="海关状态" >
                    </asp:BoundField>
                      <asp:BoundField DataField="MODIFYFLAG" HeaderText="删改单标志" >
                    </asp:BoundField>
                      <asp:BoundField DataField="PREDECLCODE" HeaderText="预制单编号" >
                    </asp:BoundField>
                      <asp:BoundField DataField="CUSNO" HeaderText="企业编号" >
                    </asp:BoundField>
                     <asp:BoundField DataField="OLDDECLARATIONCODE" HeaderText="旧报关单号" >
                    </asp:BoundField>
                   <asp:BoundField DataField="ISDEL" HeaderText="是否删除" >
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Left" />
                <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#808080" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
        </asp:GridView>
</div>
</asp:Content>
