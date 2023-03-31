import Fluent
import Leaf
import Submissions
import Vapor

public protocol AdminPanelUserControllerType: RouteCollection {
    func listHandler(_ req: Request) async throws -> View
    func createHandler(_ req: Request) async throws -> View
    func createPostHandler(_ req: Request) async throws -> Response
    func editMeHandler(_ req: Request) async throws -> View
    func editMePostHandler(_ req: Request) async throws -> Response
    func editUserHandler(_ req: Request) async throws -> View
    func editUserPostHandler(_ req: Request) async throws -> Response
    func deletePostHandler(_ req: Request) async throws -> Response
}

public final class AdminPanelUserController: AdminPanelUserControllerType {
    public func boot(routes: RoutesBuilder) throws {
        let adminAuthSessionRoutes = routes
            .grouped(AdminPanelUser.sessionAuthenticator())
            .grouped("admin", "users")
        adminAuthSessionRoutes.get(use: listHandler)
        adminAuthSessionRoutes.get("create", use: createHandler)
        adminAuthSessionRoutes.post("create", use: createPostHandler)
                
        adminAuthSessionRoutes.get(":userId", "edit", use: editUserHandler)
        adminAuthSessionRoutes.post(":userId", "edit", use: editUserPostHandler)
        adminAuthSessionRoutes.get("me", "edit", use: editMeHandler)
        adminAuthSessionRoutes.post("me", "edit", use: editMePostHandler)
    }
    
    // MARK: List
    
    public func listHandler(_ req: Request) async throws -> View {
        let users = try await AdminPanelUser.query(on: req.db).paginate(for: req)
        
        return try await req.leaf.render(
            req.adminPanel.config.views.adminPanelUser.index,
            users
        )
    }
    
    // MARK: Create user routes
    
    public func createHandler(_ req: Request) async throws -> View {
        try await req.leaf.render(req.adminPanel.config.views.adminPanelUser.editAndCreate)
    }
    
    public func createPostHandler(_ req: Request) async throws -> Response {
        try AdminPanelUser.Create.validate(content: req)
        let userCreate = try req.content.decode(AdminPanelUser.Create.self)
        let user = try AdminPanelUser(userCreate)
        try await user.create(on: req.db)
        
        let resetToken = try user.generateResetPasswordToken(context: .newUserWithoutPassword)
        try await resetToken.save(on: req.db)
        
        let url = req.adminPanel.config.baseURL.appending(
            "\(req.adminPanel.config.endpoints.resetPassword)/\(resetToken)"
        )
                
        if userCreate.shouldSpecifyPassword == false {
            _ = try await req.adminPanel.requestPasswordReset(
                for: user,
                url: url,
                token: resetToken,
                context: .newUserWithoutPassword
            )
        }
        
        return req.redirect(to: req.adminPanel.config.endpoints.adminPanelUserBasePath)
            .flash(
                .success,
                "The user with email '\(user.email)' " +
                "was created successfully."
            )
    }

    // MARK: Edit user routes
    
    public func editMeHandler(_ req: Request) async throws -> View {
        try await editHandler(req, user: try req.auth.require(AdminPanelUser.self))
    }
    
    public func editUserHandler(_ req: Request) async throws -> View {
        let userId = try req.parameters.require("userId")
        guard
            let user = try await AdminPanelUser.find(req.parameters.get("userId"), on: req.db)
        else {
            throw Abort(.notFound, reason: "User with id \(userId) not found")
        }
        return try await editHandler(req, user: user)
    }

    public func editMePostHandler(_ req: Request) async throws -> Response {
        try await editPostHandler(req, user: try req.auth.require(AdminPanelUser.self))
    }

    public func editUserPostHandler(_ req: Request) async throws -> Response {
        let userId = try req.parameters.require("userId")
        guard
            let user = try await AdminPanelUser.find(req.parameters.get("userId"), on: req.db)
        else {
            throw Abort(.notFound, reason: "User with id \(userId) not found")
        }
        return try await editPostHandler(req, user: user)
    }

    // MARK: Delete user routes

    public func deletePostHandler(_ req: Request) async throws -> Response {
        let authedUser = try req.auth.require(AdminPanelUser.self)
        let userId = try req.parameters.require("userId")
        let user = try await AdminPanelUser.find(Int(userId), on: req.db)
        let config = req.adminPanel.config
        
        guard let user else {
            throw Abort(.notFound, reason: "User with id \(userId) not found")
        }
        
        try await user.delete(on: req.db)
        
        guard authedUser.email != user.email else {
            return req.redirect(to: config.endpoints.adminPanelUserBasePath)
                .flash(.success, "Your user has now been deleted.")
        }
        
        return req.redirect(to: config.endpoints.adminPanelUserBasePath)
            .flash(.success, "The user with username '\(user.email)' " +
                   "got deleted successfully.")
    }
    
    // MARK: Private methods
    
    private func editHandler(_ req: Request, user: AdminPanelUser) async throws -> View {
        let adminPanelUser = try req.auth.require(AdminPanelUser.self)
        
        // A user may not edit a user of a higher role
        guard
            let userRole = user.role,
            let adminUserRole = adminPanelUser.role,
            userRole < adminUserRole else {
            throw Abort(.badRequest, reason: "A user may not edit a user of a higher role")
        }
        
        return try await req.leaf.render(
            req.adminPanel.config.views.adminPanelUser.editAndCreate,
            user
        )
    }
    
    private func editPostHandler(_ req: Request, user: AdminPanelUser) async throws -> Response {
        try AdminPanelUser.Create.validate(content: req)
        let config = req.adminPanel.config
        
        let updatedData = try req.content.decode(AdminPanelUser.Create.self)
        let updatedUser = try AdminPanelUser(updatedData)
        updatedUser.id = user.id
        
        try await updatedUser.save(on: req.db)
        
        return req.redirect(to: config.endpoints.adminPanelUserBasePath)
            .flash(
                .success,
                "The user with email '\(user.email)' " +
                "got updated successfully."
            )
    }
}
