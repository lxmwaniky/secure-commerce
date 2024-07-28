import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";
import List "mo:base/List";

actor SecureCommerce {
    type Transaction = {
        id: Nat;
        user: Text;
        amount: Nat;
        timestamp: Time.Time;
        status: Text;
    };

    type User = {
        id: Nat;
        name: Text;
        isBlacklisted: Bool;
    };

    var transactions: [Transaction] = [];
    var users: [User] = [];
    var nextTransactionId: Nat = 1;
    var nextUserId: Nat = 1;

    public shared(msg) func createTransaction(user: Text, amount: Nat) : async Nat {
        let newTransaction = {
            id = nextTransactionId;
            user = user;
            amount = amount;
            timestamp = Time.now();
            status = "pending";
        };
        transactions := List.append(transactions, [newTransaction]);
        nextTransactionId := nextTransactionId + 1;
        return newTransaction.id;
    };

    public shared(msg) func getTransaction(id: Nat) : async ?Transaction {
        return List.find(transactions, func (transaction) = transaction.id == id);
    };

    public shared(msg) func getAllTransactions() : async [Transaction] {
        return transactions;
    };

    public shared(msg) func updateTransactionStatus(id: Nat, status: Text) : async ?Text {
        transactions := List.map(transactions, func (transaction) {
            if (transaction.id == id) {
                return { transaction with status = status };
            } else {
                return transaction;
            }
        });
        return ?status;
    };

    public shared(msg) func addUser(name: Text, isBlacklisted: Bool) : async Nat {
        let newUser = {
            id = nextUserId;
            name = name;
            isBlacklisted = isBlacklisted;
        };
        users := List.append(users, [newUser]);
        nextUserId := nextUserId + 1;
        return newUser.id;
    };

    public shared(msg) func getUser(id: Nat) : async ?User {
        return List.find(users, func (user) = user.id == id);
    };

    public shared(msg) func getAllUsers() : async [User] {
        return users;
    };

    public shared(msg) func blacklistUser(id: Nat) : async ?Bool {
        users := List.map(users, func (user) {
            if (user.id == id) {
                return { user with isBlacklisted = true };
            } else {
                return user;
            }
        });
        return ?true;
    };

    public shared(msg) func removeBlacklist(id: Nat) : async ?Bool {
        users := List.map(users, func (user) {
            if (user.id == id) {
                return { user with isBlacklisted = false };
            } else {
                return user;
            }
        });
        return ?true;
    };
}
