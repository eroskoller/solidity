// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;




contract Ownable {
    address payable public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
         owner = payable(msg.sender);
    }

    function changeOwner(address payable  _owner) public onlyOwner returns (bool) {
        owner = _owner;
        return true;
    }
}



contract AluguelHomeWork  is Ownable {

     // Payable address can receive Ether
    // address payable public owner;

    event Track(string indexed _function, address sender, uint value, bytes data);
    event Log(bytes);

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }


    struct Aluguel {
        uint256 codigo;
        bytes32 hash;
        string locador;
        address locadorAddress;
        string locatario;
        uint256[36] parcelas;
    }

    mapping(uint256 => Aluguel) public alugueis;

    modifier validaExistenciaContrato(uint256 _codigo) {
        Aluguel memory a = alugueis[_codigo];
        require(a.codigo > 0, "Contrato inexistente!");
        _;
    }

    modifier validaValorParcela(uint256 _valor) {
        require(_valor >= 0, "Valor invalido!");
        _;
    }

    modifier validaCodigoContrato(uint256 _codigo) {
        require(_codigo >= 0, "Codigo invalido!");
        _;
    }

    modifier validaMes(uint256 _mes) {
        require(_mes <= 36, "Mes invalido!");
        _;
    }


        // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() public payable {
        emit Track("deposit()", msg.sender, msg.value, "");
    }

    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract.
    function withdraw() public {
        require(msg.sender == owner, "only owner can withdraw");
        // get the amount of Ether stored in this contract
        uint amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint _amount) public {
        // require(msg.sender == owner, "only owner can withdraw");
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    

    receive() external payable {
        // (bool success, ) = msg.sender.call{value: msg.value}("");
        // require(success, "it was not sent to the owner");
        // emit Track("receive()", msg.sender, msg.value, "");
    }

    function myBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function montaParcelas(uint256 _valor)
        private
        pure
        returns (uint256[36] memory parcelas){
        for (uint256 i = 0; i < 36; i++) {
            parcelas[i] = _valor;
        }
        return parcelas;
    }

    function contratarAluguel(
        uint256 _codigo,
        string memory _locador,
        address payable  _locadorAddress,
        string memory _locatario,
        uint256 _parcela
    )
        external
        onlyOwner
        validaValorParcela(_parcela)
        returns (bool) {
        Aluguel memory a = alugueis[_codigo];
        require(a.codigo == 0, "Codigo de contrato jah existente.");
        Aluguel memory _aluguel = Aluguel(
            _codigo,
            keccak256(bytes(string.concat(_locador, _locatario))),
            _locador,
            _locadorAddress,
            _locatario,
            montaParcelas(_parcela)
        );
        alugueis[_codigo] = _aluguel;
        return true;
    }

    function valorPorMes(uint256 _codigo, uint256 mes)
        public
        view
        validaExistenciaContrato(_codigo)
        validaCodigoContrato(_codigo)
        validaMes(mes)
        returns (uint256){
        return alugueis[_codigo].parcelas[mes -1];
    }

// Function to transfer Ether from this contract to address from input
    function pagarAluguel(uint256 _codigo, uint256 mes) 
    external 
    payable 
    validaExistenciaContrato(_codigo)
        validaCodigoContrato(_codigo)
        validaMes(mes){
        // require(msg.sender == owner, "only owner can withdraw");
        // Note that "to" is declared as payable
         Aluguel storage a = alugueis[_codigo];
         uint _index = mes -1;
         require(a.parcelas[_index] > 0, "Parcela jah foi paga.");
         require(a.parcelas[_index] == msg.value, "Valor enviado nao corresponde c o valor da parcela");
        // (bool success, ) = _to.call{value: msg.value}("");
        // (bool success, ) = _to.call{value: _amount}("");
        (bool success, bytes memory data) = a.locadorAddress.call{value: msg.value}("");
        emit Log(data);
        require(success, "Failed to send Ether");
        if(!success) revert("Falha no pagamento da parcela, revertendo operacao");
        a.parcelas[_index] = 0;
        // alugueis[_codigo] = a;
        
    }


    function nomesDasPartes(uint256 _codigo)
        public
        view
        validaExistenciaContrato(_codigo)
        returns (string memory, string memory){
        Aluguel memory a = alugueis[_codigo];
        return (a.locador, a.locatario);
    }

    function getAluguel(uint256 _codigo)
        public
        view
        validaExistenciaContrato(_codigo)
        returns (Aluguel memory){
        Aluguel memory a = alugueis[_codigo];
        return a;
    }

    function alteraNomeContratantes(
        uint256 _codigo,
        uint256 option,
        string memory name
    )
        public
        
        onlyOwner
        validaExistenciaContrato(_codigo)
        validaCodigoContrato(_codigo)
        returns (bool){

        Aluguel storage a = alugueis[_codigo];
        if (option == 1) {
            a.locador = name;
        } else if (option == 2) {
            a.locatario = name;
        } else {
            revert("Opcao invalida!");
        }
        a.hash =  keccak256(bytes(string.concat(a.locador, a.locatario)));
        // alugueis[_codigo] = a;
        return true;
    }

    function alteraValorMesesRestantes(
        uint256 _codigo,
        uint256 startMes,
        uint256 acrecimo
    )
        public
        
        validaExistenciaContrato(_codigo)
        validaMes(startMes)
        validaValorParcela(acrecimo)
        returns (bool){
        Aluguel storage a = alugueis[_codigo];
        for (uint256 i = startMes; i <= a.parcelas.length; i++) {
            a.parcelas[i-1] = a.parcelas[i-1] + acrecimo;
        }
        // alugueis[_codigo] = a;
        return true;
    }
}


contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    event Log(uint _amount, uint _gas);

    // Function to receive Ether. msg.data must be empty
    receive() external payable {

        emit Log(msg.value, gasleft());
    }

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
