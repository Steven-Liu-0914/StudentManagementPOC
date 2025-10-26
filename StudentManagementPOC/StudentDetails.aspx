<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDetails.aspx.cs" Inherits="StudentManagementPOC.StudentDetails" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <script type="text/javascript">
        function validateForm() {
            let firstName = document.getElementById('<%= txtFirstName.ClientID %>').value.trim();
            let lastName = document.getElementById('<%= txtLastName.ClientID %>').value.trim();
            let email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
            let saveBtn = document.getElementById('<%= btnSave.ClientID %>');
            let firstNameValid = /^[A-Za-z]+$/.test(firstName) && firstName.length > 0 && firstName.length <= 255;
            let lastNameValid = /^[A-Za-z]+$/.test(lastName) && lastName.length > 0 && lastName.length <= 255;
            let emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && email.length > 0 && email.length <= 255;


            document.getElementById('firstNameError').style.display = firstNameValid ? 'none' : 'inline';
            document.getElementById('lastNameError').style.display = lastNameValid ? 'none' : 'inline';
            document.getElementById('emailError').style.display = emailValid ? 'none' : 'inline';

            saveBtn.disabled = !(firstNameValid && lastNameValid && emailValid);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" class="container mt-4">
        <h2 class="mb-4">Student Details</h2>
        <asp:Panel ID="pnlStudent" runat="server" Visible="false">
            <asp:Panel ID="pnlStudentEdit1" runat="server" Visible="false">
                <div class="mb-3" runat="server">
                    <label>ID</label>
                    <asp:TextBox ID="txtStudentID" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
            </asp:Panel>

            <div class="mb-3">
                <label>First Name</label>
                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="255" onkeyup="validateForm();"></asp:TextBox>
                <span id="firstNameError" class="text-danger" style="display: none;">Only letters allowed, max 255 chars</span>
            </div>

            <div class="mb-3">
                <label>Last Name</label>
                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="255" onkeyup="validateForm();"></asp:TextBox>
                <span id="lastNameError" class="text-danger" style="display: none;">Only letters allowed, max 255 chars</span>
            </div>

            <div class="mb-3">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="255" onkeyup="validateForm();"></asp:TextBox>
                <span id="emailError" class="text-danger" style="display: none;">Invalid email format</span>
            </div>
            <asp:Panel ID="pnlStudentEdit2" runat="server" Visible="false">
                <div class="mb-3" runat="server">
                    <label>Created At</label>
                    <asp:TextBox ID="txtCreatedAt" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="mb-3" runat="server">
                    <label>Updated At</label>
                    <asp:TextBox ID="txtUpdatedAt" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
            </asp:Panel>
            <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-success me-2" OnClick="btnSave_Click">
                <i class="fa fa-save"></i> Save
            </asp:LinkButton>
            <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn btn-secondary" OnClick="btnCancel_Click">
                <i class="fa fa-arrow-left"></i> Cancel
            </asp:LinkButton>
        </asp:Panel>
        <br />
        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger mt-8" Visible="false"></asp:Label>
    </form>
</body>
</html>
