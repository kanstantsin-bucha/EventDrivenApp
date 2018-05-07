
public typealias Completion = () -> Void
public typealias ErrorCompletion<ErrorType> = (_ error : ErrorType?) -> ()
public typealias DataCompletion<DataType> = (_ data: DataType) -> ()
public typealias DataErrorCompletion<DataType, ErrorType> = (_ data: DataType, _ error: ErrorType?) -> ()


public extension String {
    
    var localized: String {
        
        return NSLocalizedString(self, comment: "")
    }
    
}
