// SPDX-License-Identifier: MIT
//0x431adaCa54bF5208D23a3D1CD464Be12b4B8083b
pragma solidity ^0.8.15;


//required revert Struct modifier

contract AlugueHomeWork {


 struct Aluguel {
        uint codigo;
        string locador;
        string locatario;
        uint[36] parcelas;
    }

   mapping(uint => Aluguel) public alugueis;

  
     modifier validaValorParcela (uint _valor) {
        require(_valor >= 0, "Valor invalido!");
        _;
    }

    modifier validaCodigoContrato (uint _codigo) {
        require(_codigo >= 0, "Codigo invalido!");
        _;
    }

    modifier validaMes (uint _mes) {
        require(_mes < 36, "Mes invalido!");
        _;
    }


    function montaParcelas(uint _valor) private pure returns (uint[36] memory parcelas) {
        for (uint i = 0; i < 36; i++) {
            parcelas[i] = _valor;
        }
        return parcelas;
    }

     function contratarAluguel(uint _codigo, string memory _locador, string memory _locatario, uint _parcela) 
     external  validaValorParcela(_parcela)
     validaCodigoContrato(_codigo) returns (bool) {
        Aluguel memory _aluguel = Aluguel(_codigo, _locador, _locatario, montaParcelas(_parcela));
        alugueis[_codigo] = _aluguel;
        return true;
    }


    function valorPorMes(uint _codigo, uint mes) public view
    validaCodigoContrato(_codigo) validaMes(mes)
     returns( uint256){
        return alugueis[_codigo].parcelas[mes];
    }

    function nomesDasPartes(uint codigo) public view returns (string memory, string memory){
        Aluguel memory a = alugueis[codigo];
        return (a.locador, a.locatario);
    }

    function alteraNomeContratantes(uint _codigo, uint option, string memory name) public  view
    validaCodigoContrato(_codigo)
     returns (bool) {
        Aluguel memory a = alugueis[_codigo];
        if(option == 1){
            a.locador = name;
        }else if(option == 2){
            a.locatario = name;
        }else{
            revert("Opcao invalida!");
        }
        return true;
    }

    function alteraValorMesesRestantes(uint codigo,uint startMes, uint256 acrecimo) public view returns (bool){
        Aluguel memory a = alugueis[codigo];
        for(uint i = startMes ; i < a.parcelas.length; i ++ ){
            a.parcelas[i] = a.parcelas[i]+acrecimo;
        }
        return true;
    }


}
