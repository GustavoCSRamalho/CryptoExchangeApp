import Foundation

protocol AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void)
}

final class AsyncExecutor: AsyncExecutorProtocol {
    func run(_ operation: @escaping () async -> Void) {
        Task {
            await operation()
        }
    }
}

final class AsyncExecutorMock: AsyncExecutorProtocol {
    
    var didRun = false
    var capturedOperation: (() async -> Void)?

    func run(_ operation: @escaping () async -> Void) {
        didRun = true
        capturedOperation = operation

        Task {
            await operation()
        }
    }
}
