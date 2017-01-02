import VaporForms
import Vapor

public struct BackendUserForm: Form {
    let name: String
    let email: String
    let role: String
    let password: String
    let sendMail: Bool
    var randomPassword = false
    
    public static let fieldset = Fieldset([
        "name": StringField(
            label: "Name"
        ),
        "email": StringField(
            label: "Email",
            String.EmailValidator()
        ),
        "role": StringField(
            label: "Role"
        ),
        "should_reset_password": StringField(
            label: "Should reset password"
        ),
        "should_reset_password": StringField(
            label: "Should reset password"
            //
        )
        ], requiring: ["name", "email", "role", "should_reset_password"])
    
    public init(validatedData: [String: Node]) throws {
        guard let name = validatedData["name"]?.string,
        let email = validatedData["email"]?.string,
        let role = validatedData["role"]?.string
        else {
            throw FormError.validationFailed(fieldset: BackendUserForm.fieldset)
        }
        
        self.name = name
        self.email = email
        self.role = role
        
        self.sendMail = validatedData["send_mail"]?.string == "true"
    
        if let password = validatedData["password"]?.string {
            self.password = password
        } else {
            password = String.randomAlphaNumericString(8)
            randomPassword = true
        }
    }
}
