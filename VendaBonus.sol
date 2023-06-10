// SPDX-License-Identifier: MIT
//0xf8e81D47203A594245E36C48e151709F0C19fBe8

pragma solidity ^0.8.15;

contract VendaBonus {

    string public nomeVendedor;
    uint256 bonus;

function setBonus(uint256 _bonus)public {
    bonus = _bonus;
}


function setNomeVendedor(string memory _nome) public {
    nomeVendedor = _nome;
}

    // constructor(uint256 _bonus , string memory _nomeVendedor){
    //     bonus = _bonus;
    //     nomeVendedor = _nomeVendedor;
    // }


    function calculaBonus(uint256 _venda) public view  returns (uint256){
        return _venda * bonus;
    }

}
