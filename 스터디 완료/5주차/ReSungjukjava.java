
import java.util.Scanner;
import java.io.IOException;

class ReSungjuk
{
	Scanner sc = new Scanner(System.in);
	ReRecord[] rrc;

	public void input() throws IOException
	{

		int inputsu;

		// �ο� �� �Է¹���
		do
		{
			System.out.print("�ο� �� �Է�(1~100) : ");
			inputsu = sc.nextInt();
		}
		while (inputsu<1 || inputsu>100);
		
		rrc = new ReRecord[inputsu];

		 // 1��° �л� ~ N��° �л����� �̸�, ����, ����, ���� ���� �Է� ����
		 //ReRecord[] rrc = new ReRecord[inputsu];
	
		 for (int i=0; i<inputsu-1; i++)
		 {
			rrc[i]= new ReRecord();
			System.out.printf("%d��° �л��� �̸� �Է�: ", (i+1));
			rrc[i].name = sc.next();

			String[] title = {"���� ���� : ", "���� ���� : ", "���� ���� : "};

			for (int j=0; j<3; j++)
			{
				System.out.print(title[j]);
				rrc[i].jumsu[j] = sc.nextInt();

				rrc[i].total += rrc[i].jumsu[j];
			}
			rrc[i].avg = rrc[i].total / 3.0;
		 }// end outfor

	}// end input()

	
	public void print()
	{
		for (int i=0; i<rrc.length; i++)
		{
			System.out.print(rrc[i].name);

			for (int j=0; j<3; j++)
			{
				System.out.println();
			}
		}
	}

		// �̸�, ����, ����, ����, ��� ���.....
}
