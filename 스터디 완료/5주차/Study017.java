
 // ���� ��)
 // �ο� �� �Է� : 5
 // �̸� ���� �Է�(1) : ������ 90
 // �̸� ���� �Է�(2) : ������ 80
 // �̸� ���� �Է�(3) : ������ 85
 // �̸� ���� �Է�(4) : ����ȣ 75
 // �̸� ���� �Է�(5) : ����ȭ 95
 /*
 ---------------------
 1�� ����ȭ 95
 2�� ������ 90
 3�� ������ 85
 4�� ������ 80
 5�� ����ȣ 75
 ---------------------
 ����Ϸ��� �ƹ� Ű�� ��������...
 */

import java.util.Scanner;

class Study017 
{
	public static void main(String[] args) 
	{
		int n=0; // n��° �ο��� ����....
		Scanner sc = new Scanner(System.in);
		
		System.out.print("�ο� �� �Է� : ");
		n = sc.nextInt();

		String[] name = new String[n];
		int[] score = new int[n];

		for (int i=0; i<name.length; i++)
		{
			System.out.printf("�̸� ���� �Է�(%d) : ", (i+1));
			name[i] = sc.next();
			score[i] = sc.nextInt();

		}

		
		// ����....!!!
		
		String temp = " ";
			
		// �ٱ� ������ ȸ��! 1ȸ�� �� 2ȸ��
		// �ٱ������� 1, ù��°����~!  --> ���� ���� Ǯ��!
		
		for (int i=0; i<name.length-1; i++)
		{
			for (int j=i+1; j<name.length; j++)
			{
				if (score[i]<score[j])
				{
					// score �迭
					score[i] = score[j]^score[i];
					score[j] = score[i]^score[j];
					score[i] = score[j]^score[i];

					temp = name[i];  
					name[i] = name[j];
					name[j] = temp;	

				}
			}
		}

	
		// ��� ����

		System.out.println("----------------------------");

		for (int i=0; i<score.length; i++)
		{
			System.out.printf("%d�� %s %d\n", i+1, name[i], score[i]);
		}

		System.out.println("----------------------------");
	}
}


