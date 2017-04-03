//
//  MoyaModelMapperSpec.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Quick
import Nimble
import Moya
@testable import MoyaModelMapper

class MoyaModelMapperSpec: QuickSpec {
    override func spec() {
        describe("MoyaModelMapper") {
            var provider: MoyaProvider<GitHub>!

            beforeEach {
                provider = MoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub)
            }

            describe("Map to Object") {
                var repo: Repository?
                var _error: MoyaError?

                beforeEach {
                    repo = nil
                    _error = nil
                }

                it("Can map response to object") {
                    waitUntil { done in
                        provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false)) { (result) in
                            if case .success(let response) = result {
                                do {
                                    repo = try response.map(to: Repository.self)
                                } catch {}
                            }
                            done()
                        }
                    }

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))
                }

                it("Can map response to object from a key path") {
                    waitUntil { done in
                        provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true)) { (result) in
                            if case .success(let response) = result {
                                do {
                                    repo = try response.map(to: Repository.self, fromKey: "data")
                                } catch {}
                            }
                            done()
                        }
                    }

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))
                }

                context("Mapping Fails") {
                    it("Can throws error if mapping fails") {
                        waitUntil { done in
                            provider.request(GitHub.repo(fullName: "no-existing-repo", keyPath: false)) { (result) in
                                if case .success(let response) = result {
                                    do {
                                        repo = try response.map(to: Repository.self)
                                    } catch {
                                        _error = error as? MoyaError
                                    }
                                }
                                done()
                            }
                        }

                        expect(repo).to(beNil())
                        expect(_error).toNot(beNil())
                        expect(_error).to(beAnInstanceOf(MoyaError.self))
                    }

                    it("Can throws error if mapping fails using key path") {
                        waitUntil { done in
                            provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true)) { (result) in
                                if case .success(let response) = result {
                                    do {
                                        repo = try response.map(to: Repository.self, fromKey: "no-existing-key")
                                    } catch {
                                        _error = error as? MoyaError
                                    }
                                }
                                done()
                            }
                        }

                        expect(repo).to(beNil())
                        expect(_error).toNot(beNil())
                        expect(_error).to(beAnInstanceOf(MoyaError.self))
                    }
                }

            }

            describe("Map to Array") {
                var repos: [Repository]?
                var _error: MoyaError?

                beforeEach {
                    repos = nil
                    _error = nil
                }

                it("can mapped to array of objects") {
                    waitUntil { done in
                        provider.request(GitHub.repos(username: "gperdomor", keyPath: false)) { (result) in
                            if case .success(let response) = result {
                                do {
                                    repos = try response.map(to: [Repository.self])
                                } catch {}
                            }
                            done()
                        }
                    }

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("can mapped to array of objects from a key path") {
                    waitUntil { done in
                        provider.request(GitHub.repos(username: "gperdomor", keyPath: true)) { (result) in
                            if case .success(let response) = result {
                                do {
                                    repos = try response.map(to: [Repository.self], fromKey: "data")
                                } catch {}
                            }
                            done()
                        }
                    }

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                context("Mapping Fails") {
                    it("Can throws error if mapping fails") {
                        waitUntil { done in
                            provider.request(GitHub.repos(username: "no-existing-user", keyPath: false)) { (result) in
                                if case .success(let response) = result {
                                    do {
                                        repos = try response.map(to: [Repository.self])
                                    } catch {
                                        _error = error as? MoyaError
                                    }
                                }
                                done()
                            }
                        }

                        expect(repos).to(beNil())
                        expect(_error).toNot(beNil())
                        expect(_error).to(beAnInstanceOf(MoyaError.self))
                    }

                    it("Can throws error if mapping fails using key path") {
                        waitUntil { done in
                            provider.request(GitHub.repos(username: "gperdomor", keyPath: true)) { (result) in
                                if case .success(let response) = result {
                                    do {
                                        repos = try response.map(to: [Repository.self], fromKey: "no-existing-key")
                                    } catch {
                                        _error = error as? MoyaError
                                    }
                                }
                                done()
                            }
                        }

                        expect(repos).to(beNil())
                        expect(_error).toNot(beNil())
                        expect(_error).to(beAnInstanceOf(MoyaError.self))
                    }
                }
            }
        }
    }
}
