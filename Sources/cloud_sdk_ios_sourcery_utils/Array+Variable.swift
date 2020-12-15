//
//  File.swift
//  
//
//  Created by Stadelman, Stan on 12/14/20.
//

import Foundation
import SourceryRuntime

extension Array where Element: Variable {
    public var templateParameterDecls: String {
        map({ "\($0.trimmedName.capitalizingFirst()): View"}).joined(separator: ", ")
    }

    public var viewBuilderInitParams: Array<String> {
        map({ "@ViewBuilder \($0.trimmedName): @escaping () -> \($0.trimmedName.capitalizingFirst())"})
    }

    public var viewBuilderPropertyDecls: String {
        map({ "private let _\($0.trimmedName): () -> \($0.trimmedName.capitalizingFirst())" }).joined(separator: "\n\t")
    }

    public var viewModifierPropertyDecls: String {
        map({ "@Environment(\\.\($0.trimmedName)Modifier) private var \($0.trimmedName)Modifier" }).joined(separator: "\n\t")
    }

    public var viewBuilderInitParamAssignment: String {
        map({ "self._\($0.trimmedName) = \($0.trimmedName)" }).joined(separator: "\n\t\t\t")
    }

    func configurationInitParams(component: String) -> String {
        map({ "\($0.trimmedName): _\($0.trimmedName)().modifier(\($0.trimmedName)Modifier.concat(Fiori.\(component).\($0.trimmedName))).typeErased" }).joined(separator: ",\n\t\t\t")
    }

    var configurationPropertyDecls: String {
        map({ "let \($0.trimmedName): AnyView" }).joined(separator: "\n\t")
    }

    var configurationPropertyViewBuilder: String {
        map({ "configuration.\($0.trimmedName)"}).joined(separator: "\n\t\t\t")
    }

    var staticViewModifierPropertyDecls: String {
        map({ "static let \($0.trimmedName) = \($0.trimmedName.capitalizingFirst())()" }).joined(separator: "\n\t\t")
    }

    var typealiasViewModifierDecls: String {
        map({ "typealias \($0.trimmedName.capitalizingFirst()) = EmptyModifier" }).joined(separator: "\n\t\t")
    }

    public var extensionContrainedWhereEmptyView: String {
        map({ "\($0.trimmedName.capitalizingFirst()) == EmptyView" }).joined(separator: ", ")
    }

    public var extensionConstrainedWhereConditionalContent: String {
        map({ "\($0.trimmedName.capitalizingFirst()) == \($0.isOptional ? "_ConditionalContent<\($0.swiftUITypeName), EmptyView>" : $0.swiftUITypeName)"}).joined(separator: ",\n\t\t")
    }

    public var extensionModelInitParams: Array<String> {
        map({ "\($0.trimmedName): \($0.typeName.name)\($0.emptyDefault)" })
    }

    public var extensionModelInitParamsAssignment: Array<String> {
        map({ "\($0.trimmedName): model.\($0.name)"})
    }

    public var extensionModelInitParamAssignments: String {
        map({ "self._\($0.trimmedName) = { \($0.conditionalAssignment) }" }).joined(separator: "\n\t\t")
    }

    var usage: String {
        reduce(into: Array<String>(), { prev, next in
            let label = prev.count > 0 ? "\(next.name):" : ""
            prev.append("\(label) {\n\t\t\tconfiguration.\(next.name)\n\t\t}")
        }).joined(separator: " ")
    }

    var acmeUsage: String {
        reduce(into: Array<String>(), { prev, next in
            let label = prev.count > 0 ? "\(next.name):" : ""
            prev.append("""
            \(label) {
                        VStack {
                            configuration.\(next.name)
                            Acme\(next.name.capitalizingFirst())View()
                        }
                    }
            """)
        }).joined(separator: " ")
    }

    public func extensionInitParamWhereEmptyView(scenario: Array<Element>) -> String {
        var output: Array<String> = []
        for variable in self {
            if !scenario.contains(variable) {
                output.append("@ViewBuilder \(variable.trimmedName): @escaping () -> \(variable.trimmedName.capitalizingFirst())")
            }
        }
        return output.joined(separator: ",\n\t\t")
    }

    public func extensionInitParamAssignmentWhereEmptyView(scenario: Array<Element>) -> String {
        var output: Array<String> = []
        for variable in self {
            if scenario.contains(variable) {
                output.append("\(variable.trimmedName): { EmptyView() }")
            } else {
                output.append("\(variable.trimmedName): \(variable.trimmedName)")
            }
        }
        return output.joined(separator: ",\n\t\t\t")
    }
}
