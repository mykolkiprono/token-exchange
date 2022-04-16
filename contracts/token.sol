import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

contract MyTokenBob is ERC20 {
    
    //when deploying pass in the name and symbol
    
    constructor (string memory name, string memory symbol) ERC20(name, symbol) public {
        //mint 100 tokens to msg.sender
        //similar to how 1 dollar = 100 cents
        //1 token = 1 * (10 ** decimals)
        
        // Mint 100 tokens with 18 decimals
        
        _mint(msg.sender, 100 * 10 ** uint(decimals()));
    }
}





contract TokenSwap {
    
    //create state variables
    
    IERC20 public token1;
    IERC20 public token2;
    address public owner1;
    address public owner2;
    
    //when deploying pass in owner 1 and owner 2
    
    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
        ) public {
            token1 = IERC20(_token1);
            owner1 = _owner1;
            token2 = IERC20(_token2);
            owner2 = _owner2;
        }
        
        //this function will allow 2 people to trade 2 tokens as the same time (atomic) and swap them between accounts
        //Bob holds token 1 and needs to send to alice
        //Alice holds token 2 and needs to send to Bob
        //this allows them to swap an amount of both tokens at the same time
        
        //*** Important ***
        //this contract needs an allowance to send tokens at token 1 and token 2 that is owned by owner 1 and owner 2
        
        function swap( uint _amount1, uint _amount2) public {
            require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
            require(token1.allowance(owner1, address(this)) >= _amount1, "Token 1 allowance too low");
            require(token2.allowance(owner1, address(this)) >= _amount1, "Token 2 allowance too low");
            
            //transfer TokenSwap
            //token1, owner1, amount 1 -> owner2.  needs to be in same order as function
            _safeTransferFrom(token1, owner1, owner2, _amount1);
            //token2, owner2, amount 2 -> owner1.  needs to be in same order as function
            _safeTransferFrom(token2, owner2, owner1, _amount2);
            
            
        }
        //This is a private function that the function above is going to call
        //the result of this transaction(bool) is assigned in a variable called sent
        //then we require the transfer to be successful
        function _safeTransferFrom(IERC20 token, address sender, address recipient, uint amount) private {bool sent = token.transferFrom(sender, recipient, amount);
            require(sent, "Token transfer failed");
            
        }
}