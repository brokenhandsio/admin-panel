import Vapor
import RegexBuilder

extension ValidatorResults {
    struct StrongPassword {
        let isStrongPassword: Bool
    }
}

extension ValidatorResults.StrongPassword: ValidatorResult {
    var isFailure: Bool {
        !isStrongPassword
    }
    
    var successDescription: String? {
        "is a strong password"
    }
    
    var failureDescription: String? {
        "is not a strong enough password"
    }
}

extension Validator where T == String {
    private static var strongPasswordRegex = Regex {
        Lookahead {
            Regex {
                ZeroOrMore(.any)
                ("a"..."z")
            }
        }
        Lookahead {
            Regex {
                ZeroOrMore(.any)
                ("A"..."Z")
            }
        }
        Lookahead {
            ChoiceOf {
                Regex {
                    ZeroOrMore(.any)
                    One(.digit)
                }
                CharacterClass(
                    // TODO: Atom characterClass(_StringProcessing.DSLTree.Atom.CharacterClass.digit)
                    ("a"..."z"),
                    ("A"..."Z")
                )
                .inverted
            }
        }
        Capture {
            Repeat(8...) {
                CharacterClass(
                    .anyOf("@$!%*#?&"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    .digit
                )
            }
        }
    }.anchorsMatchLineEndings()
    
    public static var strongPassword: Validator<T> {
        .init { data -> ValidatorResult in
            guard data.contains(strongPasswordRegex) else {
                return ValidatorResults.StrongPassword(isStrongPassword: false)
            }
            return ValidatorResults.StrongPassword(isStrongPassword: true)
        }
    }
}
