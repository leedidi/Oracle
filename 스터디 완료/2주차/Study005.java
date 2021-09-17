/*====================================
  �ߡߡ� PART 2. �׸��� & ���� �ߡߡ� 
 =====================================*/
// 2-5. �����¿�
// A�� N X N ũ���� ���簢�� ���� ���� �� ����.���� ���� ���� (1,1) ���� ������ �Ʒ� ��ǥ�� (N,N)
// ���డ A�� (1,1)���� �����ؼ� �����¿�� �̵� ����... 
// LRUD(�޿����Ʒ�) �̵�
// N X N ������ ����� �������� ���õȴ�.
// �ð����� : 15�� 
// - 8�� 13�� - 8�� 28��
// -��Ʃ�� : 38�� 08��

// ���� �ۼ��� �ڵ�
import java.util.Scanner;

public class Study005
{
	public static void main(String[] args) 
	{
		int n;			// ������ ũ�⸦ ��Ÿ���� n
		String[] plan;  // ���డ A�� �̵��� ��ȹ�� ����
		
		Scanner sc = new Scanner(System.in);

		// ù �ٿ� N X N �� N ũ��, ��° �ٿ� �����¿� ũ�� �Է� �ޱ�
		n = sc.nextInt();
		System.out.println();
		plan = sc.nextLine().split(" ");

		// �����¿� �̵��� ������ �迭
		int idong[] = {-1, 0, 1};

	}
}

// ���
import java.util.*;

public class  {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // N�� �Է¹ޱ�
        int n = sc.nextInt();
        sc.nextLine(); // ���� ����
        String[] plans = sc.nextLine().split(" ");
        int x = 1, y = 1;

        // L, R, U, D�� ���� �̵� ���� 
        int[] dx = {0, 0, -1, 1};
        int[] dy = {-1, 1, 0, 0};
        char[] moveTypes = {'L', 'R', 'U', 'D'};

        // �̵� ��ȹ�� �ϳ��� Ȯ��
        for (int i = 0; i < plans.length; i++) {
            char plan = plans[i].charAt(0);
            // �̵� �� ��ǥ ���ϱ� 
            int nx = -1, ny = -1;
            for (int j = 0; j < 4; j++) {
                if (plan == moveTypes[j]) {
                    nx = x + dx[j];
                    ny = y + dy[j];
                }
            }
            // ������ ����� ��� ���� 
            if (nx < 1 || ny < 1 || nx > n || ny > n) continue;
            // �̵� ���� 
            x = nx;
            y = ny;
        }

        System.out.println(x + " " + y);
    }

}