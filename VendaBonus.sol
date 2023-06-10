// SPDX-License-Identifier: MIT
//0x5a596ff740BbA9e83411B6f7859fbb3a3E4C4bC2

pragma solidity ^0.8.15;

contract VendaBonus {

    string public nomeVendedor;
    uint256 public bonus;

function setBonus(uint256 _bonus)public {
    bonus = _bonus;
}

function setNomeVendedor(string memory _nomeVendedor) public {
    nomeVendedor = _nomeVendedor;
}


    // constructor(uint256 _bonus , string memory _nomeVendedor){
    //     bonus = _bonus;
    //     nomeVendedor = _nomeVendedor;

    // }


    function calculaBonus(uint256 _venda) public view  returns (uint256){
        return  (_venda * bonus) / 100 ;
    }
}
