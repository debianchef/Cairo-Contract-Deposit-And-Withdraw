use snforge_std::{declare, ContractClassTrait}; 
use simplebank::Bank::{IBankDispatcher , IBankDispatcherTrait};




fn deploy_simple_bank() -> IBankDispatcher {
    let contract = declare("SimpleBank").unwrap();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    IBankDispatcher { contract_address }
}

#[test]
fn test_simple_bank() {
    // Deploy the contract using the utility function
    let dispatcher = deploy_simple_bank();

    // Call deposit function
    dispatcher.deposit(100);
    let balance = dispatcher.get_balance();
    println!("Current balance: {}", balance);

    // Call withdraw Function
    let withdrawn_amount = dispatcher.withdraw(balance);
    println!("Withdraw balance: {}", withdrawn_amount);

    // check condition
    assert_eq!(withdrawn_amount, balance);
}



#[test]
#[fuzzer(runs: 20000, seed: 1111)]
fn test_fuzz_deposit_withdraw(x: felt252) {
    let dispatcher = deploy_simple_bank();

  
        // Deposit a random amount
        dispatcher.deposit(x);
        let balance = dispatcher.get_balance();
        
        // Check if the balance is correct after deposit
        assert_eq!(balance, x, "Balance after deposit doesn't match the deposited amount");

        // Withdraw the entire balance
        let withdrawn = dispatcher.withdraw(balance);
        
        // Check if the withdrawn amount matches the balance
        assert_eq!(withdrawn, x, "Withdrawn amount doesn't match the balance");

        // Check if the balance is zero after withdrawal
        let new_balance = dispatcher.get_balance();
        assert_eq!(new_balance, 0, "Balance should be zero after full withdrawal");
  
}

