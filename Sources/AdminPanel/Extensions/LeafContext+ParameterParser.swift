import Leaf

extension LeafContext {
    func parse(index: Int, type ptype: String) throws -> String? {
        var parameter: String? = nil
        if self.parameters.count > index {
            guard let param = self.parameters[index].string else {
                throw "Bootstrap: wrong \(ptype) type given (expected a string): \(type(of: self.parameters[index]))"
            }
            
            if !param.isEmpty {
                parameter = param
            }
        }
        return parameter
    }
}
