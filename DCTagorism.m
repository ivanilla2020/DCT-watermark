
clear;
clc;

disp('choose watermark pic��');
[filename, pathname] = uigetfile('img4.jpg', 'read watermark pic');
pathfile=fullfile(pathname, filename);
markbefore=imread(pathfile); 
disp('choose original pic��');
[filename2, pathname2] = uigetfile('img5.jpg', 'read original pic');
pathfile2=fullfile(pathname2, filename2);
image=imread(pathfile2); 

markbefore2=rgb2gray(markbefore);
mark=im2bw(markbefore2);    %ʹˮӡͼ���Ϊ��ֵͼ
figure(1);      %�򿪴���
subplot(2,3,1);    %�ô����ڵ�ͼ���������������
imshow(mark),title('watermark image');   %��ʾˮӡͼ��
marksize=size(mark);   %����ˮӡͼ��ĳ���
rm=marksize(1);      %rmΪˮӡͼ�������
cm=marksize(2);     %cmΪˮӡͼ�������

I=mark;
alpha=30;     %�߶�����,����ˮӡ��ӵ�ǿ��,������Ƶ��ϵ�����޸ĵķ���
k1=randn(1,8);  %����������ͬ���������
k2=randn(1,8);
subplot(2,3,2),imshow(image,[]),title('original pic'); %[]��ʾ��ʾʱ�Ҷȷ�ΧΪimage�ϵĻҶ���Сֵ�����ֵ
yuv=rgb2ycbcr(image);   %��RGBģʽ��ԭͼ���YUVģʽ
Y=yuv(:,:,1);    %�ֱ��ȡ���㣬�ò�Ϊ�ҶȲ�
U=yuv(:,:,2);      %��Ϊ�˶����ȵ����жȴ��ڶ�ɫ�ʵ����жȣ����ˮӡǶ��ɫ�ʲ���
V=yuv(:,:,3);
[rm2,cm2]=size(U);   %�½�һ��������ͼ��ɫ�ʲ��С��ͬ�ľ���
before=blkproc(U,[8 8],'dct2');   %������ͼ��ĻҶȲ��Ϊ8��8��С�飬ÿһ��������άDCT�任������������before

after=before;   %��ʼ������ˮӡ�Ľ������
for i=1:rm          %����Ƶ��Ƕ��ˮӡ
	for j=1:cm
		x=(i-1)*8;
	    y=(j-1)*8;
	    if mark(i,j)==1
	    	k=k1;
	    else
	    	k=k2;
	    end;
	    after(x+1,y+8)=before(x+1,y+8)+alpha*k(1);
        after(x+2,y+7)=before(x+2,y+7)+alpha*k(2);
        after(x+3,y+6)=before(x+3,y+6)+alpha*k(3);
        after(x+4,y+5)=before(x+4,y+5)+alpha*k(4);
        after(x+5,y+4)=before(x+5,y+4)+alpha*k(5);
        after(x+6,y+3)=before(x+6,y+3)+alpha*k(6);
        after(x+7,y+2)=before(x+7,y+2)+alpha*k(7);
        after(x+8,y+1)=before(x+8,y+1)+alpha*k(8);
    end;
end;
result=blkproc(after,[8 8],'idct2');    %���������ͼ���Ϊ8��8��С�飬ÿһ��������άDCT��任
yuv_after=cat(3,Y,result,V);      %���������ɫ�ʲ������δ����Ĳ�ϳ�
rgb=ycbcr2rgb(yuv_after);    %ʹYUVͼ����RGBͼ��
imwrite(rgb,'markresule.jpg','jpg');      %�洢���ˮӡ���ͼ��
subplot(2,3,3),imshow(rgb,[]),title('watermarked pic');    %��ʾ���ˮӡ���ͼ��

%����ͼ�񣬲�����³����
disp('choose a way to attack��');
disp('1.add white noise');
disp('2.cut part of the pic');
disp('3.rotate 10 degrees');
disp('4.compress the pic');
disp('5.no dispose, extract watermark');
disp('input other number extract watermark');
choice=input('please choose��');
figure(1);
switch choice        %���������ѡ��  withmarkΪ�ȴ���ȡˮӡ��ͼ��
case 1
result_1=rgb;
noise=10*randn(size(result_1));    %�������������
result_1=double(result_1)+noise;        %��Ӱ�����
withmark=uint8(result_1);
subplot(2,3,4);
imshow(withmark,[]);
title('white noise added pic');     %��ʾ���˰�������ͼ��
case 2
result_2=rgb;
A=result_2(:,:,1);
B=result_2(:,:,2);
C=result_2(:,:,3);
A(1:64,1:400)=512;   %ʹͼ���Ϸ�������
B(1:64,1:400)=512;   %�ֱ������ͼ�����
C(1:64,1:400)=512; 
result_2=cat(3,A,B,C);
subplot(2,3,4);
imshow(result_2);
title('top cut pic');
figure(1);
withmark=result_2;
case 3
result_3=rgb;
result_3=imrotate(rgb,10,'bilinear','crop');   %���ڽ����Բ�ֵ�㷨��ת10��
subplot(2,3,4);
imshow(result_3);
title('10 degrees rotated pic');
withmark=result_3;
case 4
[cA1,cH1,cV1,cD1]=dwt2(rgb,'Haar');    %ͨ��С���任��ͼ�����ѹ��
cA1=HYASUO(cA1);
cH1=HYASUO(cH1);
cV1=HYASUO(cV1);
cD1=HYASUO(cD1);
result_4=idwt2(cA1,cH1,cV1,cD1,'Haar');
result_4=uint8(result_4);
subplot(2,3,4);
imshow(result_4);
title('wavelet compressed pic');
figure(1);
withmark=result_4;
case 5
subplot(2,3,4);
imshow(rgb,[]);
title('unattacked pic');
withmark=rgb;
otherwise
disp('invalid selection��extract watermark');
subplot(2,3,4);
imshow(rgb,[]);
title('unattacked pic');
withmark=rgb;
end

% �� ����Ӧ����Ҫ�ȱ��YUVģʽ���Ҵ�����_(:�١���)_
% Ӧ�ü�һ��  withmark=rgb2ycbcr(withmark);
U_2=withmark(:,:,2);         %ȡ��withmarkͼ��ĻҶȲ�
after_2=blkproc(U_2,[8,8],'dct2');   %�˲���ʼ��ȡˮӡ�����ҶȲ�ֿ����DCT�任
p=zeros(1,8);        %��ʼ����ȡ��ֵ�õľ���
for i=1:marksize(1)
for j=1:marksize(2)
x=(i-1)*8;y=(j-1)*8;
p(1)=after_2(x+1,y+8);         %��֮ǰ�ı����ֵ�ĵ����ֵ��ȡ����
p(2)=after_2(x+2,y+7);
p(3)=after_2(x+3,y+6);
p(4)=after_2(x+4,y+5);
p(5)=after_2(x+5,y+4);
p(6)=after_2(x+6,y+3);
p(7)=after_2(x+7,y+2);
p(8)=after_2(x+8,y+1);
if corr2(p,k1)>corr2(p,k2)  %corr2����������������ƶȣ�Խ�ӽ�1���ƶ�Խ��
mark_2(i,j)=0;              %�Ƚ���ȡ��������ֵ�����Ƶ��k1��k2�����ƶȣ���ԭˮӡͼ��
else
mark_2(i,j)=1;
end
end
end
subplot(2,3,5);
imshow(mark_2,[]),title('extracted watermark');
subplot(2,3,6);
imshow(mark),title('original watermark pic');
