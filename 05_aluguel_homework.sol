// SPDX-License-Identifier: MIT
//0xED217910bEeBE95a1db54B3d3AEe4BbAb7e1402b
pragma solidity ^0.8.15;




contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public onlyOwner returns (bool) {
        owner = _owner;
        return true;
    }
}



contract AluguelHomeWork  is Ownable {
    struct Aluguel {
        uint256 codigo;
        bytes32 hash;
        string locador;
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
        string memory _locatario,
        uint256 _parcela
    )
        external
        onlyOwner
        validaValorParcela(_parcela)
        validaCodigoContrato(_codigo)
        returns (bool) {
        Aluguel memory _aluguel = Aluguel(
            _codigo,
            keccak256(bytes(string.concat(_locador, _locatario))),
            _locador,
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

        Aluguel memory a = alugueis[_codigo];
        if (option == 1) {
            a.locador = name;
        } else if (option == 2) {
            a.locatario = name;
        } else {
            revert("Opcao invalida!");
        }
        a.hash =  keccak256(bytes(string.concat(a.locador, a.locatario)));
        alugueis[_codigo] = a;
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
        Aluguel memory a = alugueis[_codigo];
        for (uint256 i = startMes; i <= a.parcelas.length; i++) {
            a.parcelas[i-1] = a.parcelas[i-1] + acrecimo;
        }
        alugueis[_codigo] = a;
        return true;
    }
}
