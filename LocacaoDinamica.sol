// SPDX-License-Identifier: MIT
//0xB92394824b5a799998F74eebEdE874Bbc220d17F

pragma solidity ^0.8.15;


contract LocacaoDinamica {

    string private locador;
    string private locatario;

    uint256[] alugueis;

    constructor(string memory _locador, string memory _locatario,uint256 valorDefault){
        locador = _locador;
        locatario = _locatario;
        for(uint i = 0 ; i < 36; i ++){
            alugueis.push(valorDefault);
        }
    }

    function valorPorMes(uint mes) public view returns( uint256){
        return alugueis[mes - 1];
    }

    function nomesDasPartes() public view returns (string memory){
        string memory s1 = string.concat("locador: ", locador);
        string memory s2 = string.concat(",locatario: ", locatario);
        return string.concat(s1, s2);
    }

function alteraNomeContratantes(uint option, string memory name) public returns (bool) {
    if(option == 1){
        locador = name;
    }else if(option == 2){
        locatario = name;
    }else{
        return false;
    }
    return true;
}

function alteraValorMesesRestantes(uint startMes, uint256 acrecimo) public returns (bool){
    for(uint i = startMes ; i < alugueis.length; i ++ ){
        alugueis[i] = alugueis[i]+acrecimo;
    }
    return true;
}


}
