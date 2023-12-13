function pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
%%  pozymiai = pozymiai_raidems_atpazinti(pavadinimas, pvz_eiluciu_sk)
% Features = pozymiai_raidems_atpazinti(image_file_name, Number_of_symbols_lines)
% taikymo pavyzdys:
% pozymiai = pozymiai_raidems_atpazinti('test_data.png', 8); 
% example of function use:
% Feaures = pozymiai_raidems_atpazinti('test_data.png', 8);
%%
% Vaizdo su pavyzdĆ¾iais nuskaitymas | Read image with written symbols
V = imread(pavadinimas);
% figure(12), imshow(V)
%% RaidĆ¾iĆø iĆ°kirpimas ir sudĆ«liojimas Ć� kintamojo 'objektai' celes |
%% Perform segmentation of the symbols and write into cell variable 
% RGB image is converted to grayscale
V_pustonis = rgb2gray(V);
% vaizdo keitimo dvejetainiu slenkstinĆ«s reikĆ°mĆ«s paieĆ°ka
% a threshold value is calculated for binary image conversion
slenkstis = graythresh(V_pustonis);
% pustonio vaizdo keitimas dvejetainiu
% a grayscale image is converte to binary image
V_dvejetainis = im2bw(V_pustonis,slenkstis);
% rezultato atvaizdavimas
% show the resulting image
% figure(1), imshow(V_dvejetainis)
% vaizde esanĆØiĆø objektĆø kontĆ»rĆø paieĆ°ka
% search for the contour of each object
V_konturais = edge(uint8(V_dvejetainis));
% rezultato atvaizdavimas
% show the resulting image
% figure(2),imshow(V_konturais)
% objektĆø kontĆ»rĆø uĆ¾pildymas 
% fill the contours
se = strel('square',7); % struktĆ»rinis elementas uĆ¾pildymui
V_uzpildyti = imdilate(V_konturais, se); 
% rezultato atvaizdavimas
% show the result
% figure(3),imshow(V_uzpildyti)
% tuĆ°tumĆø objetĆø viduje uĆ¾pildymas
% fill the holes
V_vientisi= imfill(V_uzpildyti,'holes');
% rezultato atvaizdavimas
% show the result
%figure(4),imshow(V_vientisi)
% vientisĆø objektĆø dvejetainiame vaizde numeravimas
% set labels to binary image objects
[O_suzymeti Skaicius] = bwlabel(V_vientisi);
% apskaiĆØiuojami objektĆø dvejetainiame vaizde poĆ¾ymiai
% calculate features for each symbol
O_pozymiai = regionprops(O_suzymeti);
% nuskaitomos poĆ¾ymiĆø - objektĆø ribĆø koordinaĆØiĆø - reikĆ°mĆ«s
% find/read the bounding box of the symbol
O_ribos = [O_pozymiai.BoundingBox];
% kadangi ribĆ  nusako 4 koordinatĆ«s, pergrupuojame reikĆ°mes
% change the sequence of values, describing the bounding box
O_ribos = reshape(O_ribos,[4 Skaicius]); % Skaicius - objektĆø skaiĆØius
% nuskaitomos poĆ¾ymiĆø - objektĆø masĆ«s centro koordinaĆØiĆø - reikĆ°mĆ«s
% reag the mass center coordinate
O_centras = [O_pozymiai.Centroid];
% kadangi centrĆ  nusako 2 koordinatĆ«s, pergrupuojame reikĆ°mes
% group center coordinate values
O_centras = reshape(O_centras,[2 Skaicius]);
O_centras = O_centras';
% pridedamas kiekvienam objektui vaize numeris (treĆØias stulpelis Ć°alia koordinaĆØiĆø)
% set the label/number for each object in the image
O_centras(:,3) = 1:Skaicius;
% surĆ»Ć°iojami objektai pagal x koordinatĆ¦ - stulpelĆ�
% arrange objects according to the column number
O_centras = sortrows(O_centras,2);
% rĆ»Ć°iojama atsiĆ¾velgiant Ć� pavyzdĆ¾iĆø eiluĆØiĆø ir raidĆ¾iĆø skaiĆØiĆø
% sort accordign to the number of rows and number of symbols in the row
raidziu_sk = Skaicius/pvz_eiluciu_sk;
for k = 1:pvz_eiluciu_sk
    O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:) = ...
        sortrows(O_centras((k-1)*raidziu_sk+1:k*raidziu_sk,:),3);
end
% iĆ° dvejetainio vaizdo pagal objektĆø ribas iĆ°kerpami vaizdo fragmentai
% cut the symbol from initial image according to the bounding box estimated in binary image
for k = 1:Skaicius
    objektai{k} = imcrop(V_dvejetainis,O_ribos(:,O_centras(k,3)));
end
% vieno iĆ° vaizdo fragmentĆø atvaizdavimas
% show one of the symbol's image
figure(5),
for k = 1:Skaicius
   subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
end
% vaizdo fragmentai apkerpami, panaikinant fonĆ  iĆ° kraĆ°tĆø (pagal staĆØiakampĆ�)
% image segments are cutt off
for k = 1:Skaicius % Skaicius = 88, jei yra 88 raidĆ«s
    V_fragmentas = objektai{k};
    % nustatomas kiekvieno vaizdo fragmento dydis
    % estimate the size of each segment
    [aukstis, plotis] = size(V_fragmentas);
    
    % 1. BaltĆø stulpeliĆø naikinimas
    % eliminate white spaces
    % apskaiĆØiuokime kiekvieno stulpelio sumĆ 
    stulpeliu_sumos = sum(V_fragmentas,1);
    % naikiname tuos stulpelius, kur suma lygi aukĆ°ĆØiui
    V_fragmentas(:,stulpeliu_sumos == aukstis) = [];
    % perskaiĆØiuojamas objekto dydis
    [aukstis, plotis] = size(V_fragmentas);
    % 2. BaltĆø eiluĆØiĆø naikinimas
    % apskaiĆØiuokime kiekvienos seilutĆ«s sumĆ 
    eiluciu_sumos = sum(V_fragmentas,2);
    % naikiname tas eilutes, kur suma lygi ploĆØiui
    V_fragmentas(eiluciu_sumos == plotis,:) = [];
    objektai{k}=V_fragmentas;% Ć�raĆ°ome vietoje neapkarpyto
end
% vieno iĆ° vaizdo fragmentĆø atvaizdavimas
% show the segment
% figure(6),
for k = 1:Skaicius
   subplot(pvz_eiluciu_sk,raidziu_sk,k), imshow(objektai{k})
end
%%
%% Suvienodiname vaizdo fragmentĆø dydĆ¾ius iki 70x50
%% Make all segments of the same size 70x50
for k=1:Skaicius
    V_fragmentas=objektai{k};
    V_fragmentas_7050=imresize(V_fragmentas,[70,50]);
    % padalinkime vaizdo fragmentĆ  Ć� 10x10 dydĆ¾io dalis
    % divide each image into 10x10 size segments
    for m=1:7
        for n=1:5
            % apskaiĆØiuokime kiekvienos dalies vidutinĆ� Ć°viesumĆ  
            % calculate an average intensity for each 10x10 segment
            Vid_sviesumas_eilutese=sum(V_fragmentas_7050((m*10-9:m*10),(n*10-9:n*10)));
            Vid_sviesumas((m-1)*5+n)=sum(Vid_sviesumas_eilutese);
        end
    end
    % 10x10 dydĆ¾io dalyje maksimali Ć°viesumo galima reikĆ°mĆ« yra 100
    % normuokime Ć°viesumo reikĆ°mes intervale [0, 1]
    % perform normalization
    Vid_sviesumas = ((100-Vid_sviesumas)/100);
    % rezultatĆ  (poĆ¾mius) neuronĆø tinklui patogiau pateikti stulpeliu
    % transform features into column-vector
    Vid_sviesumas = Vid_sviesumas(:);
    % iĆ°saugome apskaiĆØiuotus poĆ¾ymius Ć� bendrĆ  kintamĆ jĆ�
    % save all fratures into single variable
    pozymiai{k} = Vid_sviesumas;
end
