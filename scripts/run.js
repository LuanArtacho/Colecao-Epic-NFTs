const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT"); //Isso vai na verdade compilar o nosso contrato e gerar os arquivos necessários que precisamos para trabalhar com o nosso contrato dentro do diretório artifacts. Cheque depois de rodar isso :).
    const nftContract = await nftContractFactory.deploy(); //O que está acontecendo aqui é que o Hardhat cria uma rede Ethereum local para a gente, mas só para esse contrato. Depois que o script for completo, ele vai destruir essa rede local. Então, cada vez que você rodar o contrato, será uma blockchain nova. E qual é o objetivo? É como refazer o seu server local toda vez, de maneira que você sempre parta de um ponto limpo, o que deixa mais fácil o debug de erros.
    await nftContract.deployed(); //Nós vamos esperar até que o nosso contrato esteja oficialmente minerado e implantado na nossa blockchain local! Exatamente, hardhat cria "mineradores" falsos na nossa máquina para tentar imitar da melhor forma a blockchain. Nosso constructor roda quando nós estamos completamente implantados (deployed)!
    console.log("Contrato implantado em:", nftContract.address); //Finalmente, uma vez que estiver implantado, nftContract.address vai basicamente nos dar o endereço do contrato implementado. Esse endereço é como nós vamos achar o nosso contrato na blockchain. Nesse momento nossa blockchain local só tem nós.
  // Chama a função.
  let txn = await nftContract.makeAnEpicNFT();
  // Espera ela ser minerada.
  await txn.wait();
  // Minta outra NFT por diversão.
  txn = await nftContract.makeAnEpicNFT();
  // Espera ela ser minerada.
  await txn.wait();
};
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();