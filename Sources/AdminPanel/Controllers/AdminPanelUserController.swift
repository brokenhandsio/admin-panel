import Fluent
import Leaf
import Vapor

public protocol AdminPanelUserControllerType: RouteCollection {
    func listHandler(_ req: Request) async throws -> Response
    func createHandler(_ req: Request) async throws -> Response
    func createPostHandler(_ req: Request) async throws -> Response
    func editMeHandler(_ req: Request) async throws -> Response
    func editMePostHandler(_ req: Request) async throws -> Response
    func editUserHandler(_ req: Request) async throws -> Response
    func editUserPostHandler(_ req: Request) async throws -> Response
    func deletePostHandler(_ req: Request) async throws -> Response
}

public final class AdminPanelUserController: AdminPanelUserControllerType {
    public func boot(routes: RoutesBuilder) throws {
        routes.get(use: listHandler)
        routes.get("create", use: createHandler)
        routes.post("create", use: createPostHandler)
                
        routes.get(":userId", "edit", use: editUserHandler)
        routes.post(":userId", "edit", use: editUserPostHandler)
        routes.get("me", "edit", use: editMeHandler)
        routes.post("me", "edit", use: editMePostHandler)
        routes.post(":userId", "delete", use: deletePostHandler)
    }
    
    // MARK: List
    
    public func listHandler(_ req: Request) async throws -> Response {
        // TODO: Paginate users
        let users = try await AdminPanelUser.query(on: req.db).all()
        
        return try await req.leaf.render(
            req.adminPanel.config.views.adminPanelUser.index,
            ["users": users]
        ).encodeResponse(for: req)
    }
    
    // MARK: Create user routes
    
    public func createHandler(_ req: Request) async throws -> Response {
        try await req.leaf.render(req.adminPanel.config.views.adminPanelUser.editAndCreate)
            .encodeResponse(for: req)
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
            try await req.adminPanel.requestPasswordReset(
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
    
    public func editMeHandler(_ req: Request) async throws -> Response {
        try await editHandler(req, user: try req.auth.require(AdminPanelUser.self))
    }
    
    public func editUserHandler(_ req: Request) async throws -> Response {
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
    
    private func editHandler(_ req: Request, user: AdminPanelUser) async throws -> Response {
        let adminPanelUser = try req.auth.require(AdminPanelUser.self)
        
        // A user may not edit a user of a higher role
        guard
            let userRole = user.role,
            let adminUserRole = adminPanelUser.role,
            userRole <= adminUserRole else {
            throw Abort(.badRequest, reason: "A user may not edit a user of a higher role")
        }
        
        return try await req.leaf.render(
            req.adminPanel.config.views.adminPanelUser.editAndCreate,
            ["user": user]
        ).encodeResponse(for: req)
    }
    
    private func editPostHandler(_ req: Request, user: AdminPanelUser) async throws -> Response {
        try AdminPanelUser.Update.validate(content: req)
        let config = req.adminPanel.config
        
        let updatedData = try req.content.decode(AdminPanelUser.Update.self)
        try user.update(with: updatedData)
                
        try await user.update(on: req.db)
        
        return req.redirect(to: config.endpoints.adminPanelUserBasePath)
            .flash(
                .success,
                "The user with email '\(user.email)' " +
                "got updated successfully."
            )
    }
}
